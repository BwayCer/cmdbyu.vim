void main() {
  doSomething((int s) => 's', 5);
    doSomething2(xToString);
      }

        String xToString(int s) => 's';

          typedef String XToStringFn(int s);

            void doSomething(
              String f(int x),
                int choB
                  ) {
                    print('value: ${f(123)}');
                      }

                        void doSomething2(
                          XToStringFn f
                            ) {
                              print('value: ${f(123)}');
                                }
