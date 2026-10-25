# Testing

- Name each test as a specification of its behavior: the subject and what it
  should do, like "something should do something" in an English domain and
  "etwas sollte etwas tun" in a German domain.
- Structure each test with Arrange-Act-Assert.
- Test behavior through the public interface, not the implementation.
- Verify one behavior per test.
- Keep tests deterministic: pass the current time, random values and generated
  identities in instead of reading them.
- Test the domain without test doubles. Use them only for the infrastructure at
  the edge of the shell.
