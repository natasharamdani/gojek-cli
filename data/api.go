package main

import(
  "os"
  "fmt"
  "time"
  "strconv"
  "net/http"
  "io/ioutil"
  "encoding/json"
)

type User struct {
  Name     string `json:"name"`
  Email    string `json:"email"`
  Phone    string `json:"phone"`
  Password string `json:"password"`
  Gopay    int    `json:"gopay"`
}

type Orders []struct {
  Timestamp   string `json:"timestamp"`
  Origin      string `json:"origin"`
  Destination string `json:"destination"`
  EstPrice    int    `json:"est_price"`
  Type        string `json:"type"`
  Driver      string `json:"driver"`
}

type Order struct {
  Timestamp   string `json:"timestamp"`
  Origin      string `json:"origin"`
  Destination string `json:"destination"`
  EstPrice    int    `json:"est_price"`
  Type        string `json:"type"`
  Driver      string `json:"driver"`
}

func ServeHome(w http.ResponseWriter, r *http.Request) {
  fmt.Fprintln(w, "MENU")
  fmt.Fprintln(w, "User Profile: /user")
  fmt.Fprintln(w, "Order GoRide: /order")
}

func ServeUser(w http.ResponseWriter, r *http.Request) {
  w.Header().Set("Content-Type", "application/json")

  u := UserFromFile("user.json")

  switch r.Method {
  case "GET":
    bs, _ := json.Marshal(u)
    fmt.Fprintln(w, string(bs))
  case "PATCH":
    if r.FormValue("name") != "" { u.Name = r.FormValue("name") }
    if r.FormValue("email") != "" { u.Email = r.FormValue("email") }
    if r.FormValue("phone") != "" { u.Phone = r.FormValue("phone") }
    if r.FormValue("password") != "" { u.Password = r.FormValue("password") }
    if r.FormValue("gopay") != "" { u.Gopay, _ = strconv.Atoi(r.FormValue("gopay")) }
    u.Save("user.json")

    u := UserFromFile("user.json")
    bs, _ := json.Marshal(u)
    fmt.Fprintln(w, string(bs))
  default:
    fmt.Fprintln(w, "Please use GET or PATCH")
  }
}

func ServeOrder(w http.ResponseWriter, r *http.Request) {
  w.Header().Set("Content-Type", "application/json")

  o := OrdersFromFile("orders.json")

  switch r.Method {
  case "GET":
    bs, _ := json.Marshal(o)
    fmt.Fprintln(w, string(bs))
  case "POST":
    item := Order{}
    item.Timestamp = time.Now().Format("2006-01-02 15:04:05 -0700")
    item.Origin = r.FormValue("origin")
    item.Destination = r.FormValue("destination")
    item.EstPrice, _ = strconv.Atoi(r.FormValue("est_price"))
    item.Type = r.FormValue("type")
    item.Driver = r.FormValue("driver")
    o = append(o, item)

    o.Save("orders.json")

    o := OrdersFromFile("orders.json")
    bs, _ := json.Marshal(o)
    fmt.Fprintln(w, string(bs))
  default:
    fmt.Fprintln(w, "Please use GET or POST")
  }
}

func main() {
  http.HandleFunc("/", ServeHome)
  http.HandleFunc("/user", ServeUser)
  http.HandleFunc("/order", ServeOrder)
  http.ListenAndServe(":8080", nil)
}

// begin of user parse
func (u User) Save(f string) error {
  return ioutil.WriteFile(f, u.toJson(), 0644)
}

func (u User) toJson() []byte {
  bs, err := json.Marshal(u)
  if err != nil {
    fmt.Println(err)
    os.Exit(1)
  }
  return bs
}

func UserFromFile(f string) User {
  bs, err := ioutil.ReadFile(f)
  if err != nil {
    return User{}
  }
  return UserFromJson(bs)
}

func UserFromJson(bs []byte) User {
  var u User
  err := json.Unmarshal(bs, &u)
  if err != nil {
    fmt.Println(err)
    os.Exit(1)
  }
  return u
}
// end of user parse

// begin of orders parse
func (o Orders) Save(f string) error {
  return ioutil.WriteFile(f, o.toJson(), 0644)
}

func (o Orders) toJson() []byte {
  bs, _ := json.Marshal(o)
  return bs
}

func OrdersFromFile(f string) Orders {
  bs, _ := ioutil.ReadFile(f)
  return OrdersFromJson(bs)
}

func OrdersFromJson(bs []byte) Orders {
  var o Orders
  _ = json.Unmarshal(bs, &o)
  return o
}
// end of orders parse