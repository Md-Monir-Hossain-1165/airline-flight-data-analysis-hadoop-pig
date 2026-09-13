package flightanalysis;

import java.io.IOException;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

/** Calculates mean recorded arrival delay, in minutes, for each airline. */
public class AverageArrivalDelayByAirline {
  public static class Map extends Mapper<LongWritable, Text, Text, Text> {
    public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
      String[] f = value.toString().split(",", -1);
      if (f.length == 31 && !"YEAR".equals(f[0]) && !f[4].trim().isEmpty() && !f[22].trim().isEmpty()) {
        try { context.write(new Text(f[4]), new Text(f[22] + "\t1")); } catch (NumberFormatException ignored) { }
      }
    }
  }
  public static class Reduce extends Reducer<Text, Text, Text, Text> {
    public void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
      double sum = 0; long count = 0;
      for (Text value : values) { String[] pair = value.toString().split("\t"); sum += Double.parseDouble(pair[0]); count += Long.parseLong(pair[1]); }
      context.write(key, new Text(String.format("%.2f", (double) sum / count)));
    }
  }
  public static void main(String[] args) throws Exception {
    Configuration conf = new Configuration(); conf.set("fs.defaultFS", "file:///"); conf.set("mapreduce.framework.name", "local");
    Job job = Job.getInstance(conf, "Average arrival delay by airline");
    job.setJarByClass(AverageArrivalDelayByAirline.class); job.setMapperClass(Map.class); job.setReducerClass(Reduce.class);
    job.setMapOutputKeyClass(Text.class); job.setMapOutputValueClass(Text.class); job.setOutputKeyClass(Text.class); job.setOutputValueClass(Text.class);
    FileInputFormat.addInputPath(job, new Path(args[0])); FileOutputFormat.setOutputPath(job, new Path(args[1]));
    System.exit(job.waitForCompletion(true) ? 0 : 1);
  }
}
