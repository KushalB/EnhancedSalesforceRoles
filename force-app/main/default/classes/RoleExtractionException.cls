/**
 * @description       :
 * @author            : kushalbasu2@gmail.com
 * @group             :
 * @last modified on  : 02-02-2023
 * @last modified by  : github.com/kushalb
 **/
public class RoleExtractionException extends Exception {
  public String getExceptionErrorMessage() {
    return this.getMessage() + '\n' + this.getStackTraceString();
  }
}
