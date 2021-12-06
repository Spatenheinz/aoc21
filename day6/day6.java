import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.HashMap;

class Day6 {
    private static HashMap<Integer, Long> set = new HashMap<Integer, Long>();
    private final static Integer part1 = 80;
    private final static Integer part2 = 256;
    private static Long solve(Integer days) {
        HashMap<Integer, Long> newset = set;
        for (int i = 0; i < days; i++) {
            HashMap<Integer, Long> running_set = new HashMap<Integer, Long>();
            for (Integer key : newset.keySet()) {
                Long count = newset.get(key);
                if (key > 0) {
                    Long present = running_set.computeIfPresent(key - 1, (k,v) -> v + count);
                    if (present == null) {
                        running_set.put(key - 1, count);
                    }
                } else {
                    Long present  = running_set.computeIfPresent(6, (k,v) -> v + count);
                    if (present  == null) {
                        running_set.put(6, count);
                    }
                    present = running_set.computeIfPresent(8, (k,v) -> v + count);
                    if (present  == null) {
                        running_set.put(8, count);
                    }
                }
            }
            newset = running_set;
        }
        return newset.values().stream().mapToLong(Long::longValue).sum();
    }

    public static void main(String[] args) {
        try {
        Path fileName = Path.of("input.txt");
	    String content  = Files.readString(fileName);
        String[] convertedRankArray = content.split(",");
        for (String number : convertedRankArray) {
            Integer numberAsInt = Integer.parseInt(number.trim());
            Long amount = set.computeIfPresent(numberAsInt, (k,v) -> v+1);
            if (amount == null) {
                set.put(numberAsInt, 1L);
            }
        }
        System.out.println(solve(part1));
        System.out.println(solve(part2));
        } catch(IOException e) {
            ;
        }
    }
}
