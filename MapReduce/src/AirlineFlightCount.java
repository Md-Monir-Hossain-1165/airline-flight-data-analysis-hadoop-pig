package flightanalysis;

import java.io.IOException;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

/** Counts all scheduled flight records for each airline code. */
public class AirlineFlightCount {
  public static class Map extends Mapper<LongWritable, Text, Text, IntWritable> {
    private static final IntWritable ONE = new IntWritable(1);
    public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
      String[] f = value.toString().split(",", -1);
      if (f.length == 31 && !"YEAR".equals(f[0]) && !f[4].trim().isEmpty()) context.write(new Text(f[4]), ONE);
    }
  }
  public static class Reduce extends Reducer<Text, IntWritable, Text, IntWritable> {
    public void reduce(Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {
      int total = 0; for (IntWritable value : values) total += value.get();
      context.write(key, new IntWritable(total));
    }
  }
  public static void main(String[] args) throws Exception {
    Configuration conf = new Configuration(); conf.set("fs.defaultFS", "file:///"); conf.set("mapreduce.framework.name", "local");
    Job job = Job.getInstance(conf, "Flight count by airline");
    job.setJarByClass(AirlineFlightCount.class); job.setMapperClass(Map.class); job.setReducerClass(Reduce.class);
    job.setOutputKeyClass(Text.class); job.setOutputValueClass(IntWritable.class);
    FileInputFormat.addInputPath(job, new Path(args[0])); FileOutputFormat.setOutputPath(job, new Path(args[1]));
    System.exit(job.waitForCompletion(true) ? 0 : 1);
  }
}
