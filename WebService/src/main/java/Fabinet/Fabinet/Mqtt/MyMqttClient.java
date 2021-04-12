package Fabinet.Fabinet.Mqtt;

import org.eclipse.paho.client.mqttv3.*;

import java.util.HashMap;
import java.util.function.Consumer;

public class MyMqttClient implements MqttCallback {

    private MqttClient client;
    private MqttConnectOptions option;
    private Consumer<HashMap<Object, Object>> FNC = null;  //메시지 도착 후 응답하는 함수
    private Consumer<HashMap<Object, Object>> FNC2 = null; //커넥션이 끊긴 후 응답하는 함수
    private Consumer<HashMap<Object, Object>> FNC3 = null; //전송이 완료된 이후 응답하는 함수.

    public MyMqttClient (Consumer<HashMap<Object, Object>> fnc){
        this.FNC = fnc;
    }

    public MyMqttClient init(String userName, String password, String serverURI, String clientId){
        option = new MqttConnectOptions();
        option.setCleanSession(true);
        option.setKeepAliveInterval(30);
        option.setUserName(userName);
        option.setPassword(password.toCharArray());  //옵션 객체에 접속하기위한 세팅끝!
        try {
            client = new MqttClient(serverURI, clientId);
            client.setCallback(this);
            client.connect(option);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return this;
    }

    //토픽 구독
    public boolean subscribe(String... topics){
        try {
            if(topics != null){
                for(String topic : topics){
                    client.subscribe(topic,0);  //구독할 주제, 숫자는 품질 값
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    //메세지 전송
    public boolean sender(String topic, String msg) throws MqttPersistenceException, MqttException{
        MqttMessage message = new MqttMessage();
        message.setPayload(msg.getBytes());  //보낼 메시지
        client.publish(topic, message);  //토픽과 함께 보낸다.
        return false;
    }

    /**
     * 커넥션이 끊어진 이후의 콜백행위를 등록
     * 해쉬맵 형태의 결과에 키는 result, 값은 Throwable 객체를 반환
     * **/
    public void initConnectionLost (Consumer<HashMap<Object, Object>> fnc){
        FNC2 = fnc;
    }


    /**
     * 커넥션이 끊어진 이후의 콜백행위를 등록
     * 해쉬맵 형태의 결과에 키는 result, 값은 IMqttDeliveryToken 객체를 반환
     * **/
    public void initDeliveryComplete (Consumer<HashMap<Object, Object>> fnc){
        FNC3 = fnc;
    }


    @Override
    public void connectionLost(Throwable cause) {
        if(FNC2 != null){
            HashMap<Object, Object> result = new HashMap<>();
            result.put("result", cause);
            FNC2.accept(result);
            cause.printStackTrace();
        }
    }

    //메세지 도착
    @Override
    public void messageArrived(String topic, MqttMessage message) throws Exception {
        if(FNC != null){
            HashMap<Object, Object> result = new HashMap<>();
            result.put("topic", topic);
            result.put("message", new String(message.getPayload(),"UTF-8"));
            FNC.accept(result);  //콜백행위 실행
        }
    }

    @Override
    public void deliveryComplete(IMqttDeliveryToken token) {
        if(FNC3 != null){
            HashMap<Object, Object> result = new HashMap<>();
            try {
                result.put("result", token);
            } catch (Exception e) {
                e.printStackTrace();
                result.put("result", "ERROR");
                result.put("error", e.getMessage());
            }
            FNC3.accept(result);
        }
    }

    /**
     * 종료메소드
     * 클라이언트를 종료 합니다.
     * */
    public void close(){
        if(client != null){
            try {
                client.disconnect();
                client.close();
            } catch (MqttException e) {
                e.printStackTrace();
            }
        }
    }
}
