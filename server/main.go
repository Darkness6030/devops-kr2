package main
import (
 "context"
 "crypto/rand"
 "crypto/tls"
 "crypto/x509"
 "log"
 "math/big"
 "net"
 "os"
 "time"
 "google.golang.org/grpc"
 "google.golang.org/grpc/credentials"
 "google.golang.org/grpc/peer"
 "google.golang.org/grpc/status"
 "python_go_grpc/server/api"
)
type dice struct { api.UnimplementedDiceServiceServer }
func (s *dice) RollDie(context.Context, *api.RollDieRequest) (*api.RollDieResponse,error) {
 n,err:=rand.Int(rand.Reader,big.NewInt(6));if err!=nil{return nil,err}
 return &api.RollDieResponse{Value:int32(n.Int64()+1)},nil
}
func logger(ctx context.Context, req interface{}, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler)(interface{},error){
 start:=time.Now();result,err:=handler(ctx,req);p,_:=peer.FromContext(ctx)
 log.Printf("peer=%v method=%s status=%s duration=%s",p.Addr,info.FullMethod,status.Code(err),time.Since(start));return result,err
}
func serve(addr string, opts ...grpc.ServerOption){
 lis,err:=net.Listen("tcp",addr);if err!=nil{log.Fatal(err)}
 opts=append(opts,grpc.UnaryInterceptor(logger));s:=grpc.NewServer(opts...)
 api.RegisterDiceServiceServer(s,&dice{});log.Printf("listening %s",addr);log.Fatal(s.Serve(lis))
}
func main(){
 pair,err:=tls.LoadX509KeyPair("certs/server.pem","certs/server-key.pem");if err!=nil{log.Fatal(err)}
 pem,err:=os.ReadFile("certs/ca.pem");if err!=nil{log.Fatal(err)}
 roots:=x509.NewCertPool();if !roots.AppendCertsFromPEM(pem){log.Fatal("invalid CA")}
 cfg:=&tls.Config{MinVersion:tls.VersionTLS12,Certificates:[]tls.Certificate{pair},ClientCAs:roots,ClientAuth:tls.RequireAndVerifyClientCert}
 go serve("127.0.0.1:50051")
 serve("127.0.0.1:8443",grpc.Creds(credentials.NewTLS(cfg)))
}
