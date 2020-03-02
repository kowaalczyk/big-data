import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FSDataOutputStream;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.hdfs.DistributedFileSystem;

import java.io.PrintWriter;
import java.net.URI;

/**
 * Based on: https://www.allprogrammingtutorials.com/tutorials/reading-writing-files-in-hdfs-using-java-api.php
 */
public class HDFSJavaAPIWriteDemo {
    public static void main(String[] args) throws Exception {
        // Impersonates user "root" to avoid performance problems. You should replace it
        // with user that you are running your HDFS cluster with
        System.setProperty("HADOOP_USER_NAME", "root");

        // Path that we need to create in HDFS. Just like Unix/Linux file systems, HDFS file system starts with "/"
        final Path path = new Path("/user/tutorials-links.txt");

        // Uses try with resources in order to avoid close calls on resources
        // Creates anonymous sub class of DistributedFileSystem to allow calling initialize as DFS will not be usable otherwise
        try (final DistributedFileSystem dFS = new DistributedFileSystem() {
            {
                initialize(new URI("hdfs://master:9000"), new Configuration());
            }
        };
             // Gets output stream for input path using DFS instance
             final FSDataOutputStream streamWriter = dFS.create(path);
             // Wraps output stream into PrintWriter to use high level and sophisticated methods
             final PrintWriter writer = new PrintWriter(streamWriter);) {
            // Writes tutorials information to file using print writer
            writer.println("Getting Started with Apache Spark => http://www.allprogrammingtutorials.com/tutorials/getting-started-with-apache-spark.php");
            writer.println("Developing Java Applications in Apache Spark => http://www.allprogrammingtutorials.com/tutorials/developing-java-applications-in-spark.php");
            writer.println("Getting Started with RDDs in Apache Spark => http://www.allprogrammingtutorials.com/tutorials/getting-started-with-rdds-in-spark.php");

            System.out.println("File Written to HDFS successfully!");
        }
    }
}
