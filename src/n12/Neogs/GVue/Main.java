package n12.Neogs.GVue;

import java.io.IOException;
import java.lang.String;
import java.lang.

/**
 * Created by neogs on 6/23/15.
 */
public class Main {
    Runtime run = Runtime.getRuntime();
//The best possible I found is to construct a command which you want to execute
//as a string and use that in exec. If the batch file takes command line arguments
//the command can be constructed a array of strings and pass the array as input to
//the exec method. The command can also be passed externally as input to the method.

    Process p = null;
    String cmd = "ls";

    while(1)

    {

        try {
            p = run.exec(cmd);

            p.getErrorStream();
            p.waitFor();

        } catch (IOException e) {
            e.printStackTrace();
            System.out.println("ERROR.RUNNING.CMD");
        } finally {
            p.destroy();
        }
    }
}
