package Jongsul.fabinetmaven.Service;


import Jongsul.fabinetmaven.Domain.Image;

import java.util.List;

public interface ImageService {

    public String join(Image image);
    public List<Image> findOne(String imageName);
//    public List<Member> findMembers();
//    public String login(String id, String password);
//    public String isExistId(String id);
}
