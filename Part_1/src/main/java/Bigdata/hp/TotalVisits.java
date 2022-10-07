package Bigdata.hp;


import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;

import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class TotalVisits {

   public static class TotalVisitsMapper extends
           Mapper<Object, Text, Text, IntWritable> {

       private final static IntWritable one = new IntWritable(1);
       private Text visit = new Text();

       public void map(Object key, Text value, Context context)
               throws IOException, InterruptedException {
    	   String rw = value.toString();
    	   
    	   String visitMatch = "";
    	   
    	   Pattern pattern = Pattern.compile("\"GET /[english|french].*[.htm|html] HTTP.*\"");
           Matcher matcher = pattern.matcher(rw);
           
           if(matcher.find())
           {
        	   visitMatch = matcher.group();
        	   String[] KeyString =  visitMatch.split(" ");
        	   String url = KeyString[1];
        	   
        	   visit.set(url);
        	   context.write(visit, one);
           }
           }   
       }
   

   public static class IntSumReducer extends
           Reducer<Text, IntWritable, Text, IntWritable> {
       private IntWritable result = new IntWritable();

       public void reduce(Text key, Iterable<IntWritable> values,
                          Context context) throws IOException, InterruptedException {
           int sum = 0;
           for (IntWritable val : values) {
               sum += val.get();
           }

           result.set(sum);
           context.write(new Text("Total:"), result);

       }
   }

   public static void main(String[] args) throws Exception {
       Configuration conf = new Configuration();
       String[] otherArgs = new GenericOptionsParser(conf, args)
               .getRemainingArgs();
       if (otherArgs.length != 2) {
           System.err.println("Usage: Visit count <in> <out>");
           System.exit(2);
       }
       Job job = Job.getInstance(conf, "Visit count");
       job.setJarByClass(TotalVisits.class);
       job.setMapperClass(TotalVisitsMapper.class);
       job.setCombinerClass(IntSumReducer.class);
       job.setReducerClass(IntSumReducer.class);
       job.setOutputKeyClass(Text.class);
       job.setOutputValueClass(IntWritable.class);
       FileInputFormat.addInputPath(job, new Path(otherArgs[0]));
       FileOutputFormat.setOutputPath(job, new Path(otherArgs[1]));
       System.exit(job.waitForCompletion(true) ? 0 : 1);
   }
}

