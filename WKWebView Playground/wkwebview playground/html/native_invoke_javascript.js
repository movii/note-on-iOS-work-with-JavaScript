(function (win, doc) {
  const sayHello = () => {
    alert('Hello (sayHello() invoked from javascript)');
  }
  const sayHelloTo = (name) => {
    alert(`Hello, ${name}! (sayHelloTo(name) invoked from javascript)`);
  }
  const sayHelloToWithReply = (name) => {
    alert(`Hello, ${name}! (sayHelloToWithReply() invoked from javascript)`);
    return `Hello ${name}! (sayHelloToWithReply() invoked from javascript)`
  }

  win.sayHello = sayHello;
  win.sayHelloTo = sayHelloTo;
  win.sayHelloToWithReply = sayHelloToWithReply;
}(window, document))