import java.util.Comparator;

class ImageComp implements Comparator<Image>{//compare image brightness
  @Override
  public int compare(Image a, Image b){
    return brightness(a.avgCol) < brightness(b.avgCol) ? 1 : -1;
  }
}
