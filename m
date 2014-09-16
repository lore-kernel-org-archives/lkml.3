Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbaIPIAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 04:00:11 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:54444 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaIPIAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 04:00:08 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed
X-AuditID: cbfee68f-f797f6d000001173-c0-5417edfec587
Content-transfer-encoding: 8BIT
Message-id: <5417EDFE.7030700@samsung.com>
Date: Tue, 16 Sep 2014 16:59:58 +0900
From: Jaewon Kim <jaewon02.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.1
To: Lee Jones <lee.jones@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v4 4/4] mfd: max77693: Update DT binding to support haptic
References: <1410440062-19963-1-git-send-email-jaewon02.kim@samsung.com>
 <1410440062-19963-5-git-send-email-jaewon02.kim@samsung.com>
 <20140915230043.GI25162@lee--X1>
In-reply-to: <20140915230043.GI25162@lee--X1>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsWyRsSkRPffW/EQg7Pn1Cyuf3nOanF40QtG
	i/tfjzJa3Pz0jdXi8q45bBanu1kd2Dx2zrrL7nHn2h42j3knAz36tqxi9Pi8SS6ANYrLJiU1
	J7MstUjfLoErY/+DmSwFn8QqXrVXNTD2CXUxcnJICJhInP5ymh3CFpO4cG89WxcjF4eQwFJG
	iZdv2llhig7s72GFSCxilLj25CwzSIJXQFDix+R7LF2MHBzMAvISRy5lg4SZBcwkvrw8DFX/
	mlHiyITnrBD1WhJXfjYxgtgsAqoSyyZsZwGx2QS0Jb6vXwxWIyoQITHp4G1GkJkiAioS596Y
	g8xhFtjFKLF+xnWwXmEBP4kZS65AXbqKUeL25ilgL3AK6EosbbnIApKQEDjFLvH0aBMbxDYB
	iW+TD4FdKiEgK7HpADPEZ5ISB1fcYJnAKDYLyT+zEP6ZheSfBYzMqxhFUwuSC4qT0ouM9YoT
	c4tL89L1kvNzNzEC4+z0v2f9OxjvHrA+xCjAwajEw+vxSDxEiDWxrLgy9xCjKdARE5mlRJPz
	gdGcVxJvaGxmZGFqYmpsZG5ppiTOu1DqZ7CQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxuLs
	henM9Qv/irxSVvpn5vtDQ/D8hDtuj/WOTzBOczjtFPXxge2RtmO2Yqu+CN778TB1vv13kw8v
	vxmkqSne7m5ZsmCTSl57xAr/CZ5O/wIWm2lM9chd9+9o1SqGvvjM5zYB/1pvMhZs8DHuuuWw
	kIXpiwvTyUT9htlrJrHs3mtwduaH53zZB5VYijMSDbWYi4oTAST0i3WuAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jAd1/b8VDDJ6/krO4/uU5q8XhRS8Y
	Le5/PcpocfPTN1aLy7vmsFmc7mZ1YPPYOesuu8eda3vYPOadDPTo27KK0ePzJrkA1qgGRpuM
	1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoAOUFMoSc0qB
	QgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBn7H8xkKfgkVvGqvaqBsU+oi5GTQ0LA
	ROLA/h5WCFtM4sK99WxdjFwcQgKLGCWuPTnLDJLgFRCU+DH5HksXIwcHs4C8xJFL2SBhZgEz
	iS8vD7NC1L9mlDgy4TkrRL2WxJWfTYwgNouAqsSyCdtZQGw2AW2J7+sXg9WICkRITDp4mxFk
	poiAisS5N+Ygc5gFdjFKrJ9xHaxXWMBPYsaSK1AHrWKUuL15CjtIglNAV2Jpy0WWCYwCs5Dc
	NwvhvllI7lvAyLyKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIziKn0nvYFzVYHGIUYCDUYmH
	1+OReIgQa2JZcWXuIUYJDmYlEd5/L4FCvCmJlVWpRfnxRaU5qcWHGE2BvpvILCWanA9MMHkl
	8YbGJmZGlkbmhhZGxuZK4rwHW60DhQTSE0tSs1NTC1KLYPqYODilGhgXSZy5rKB2LmvipyPx
	RyZfj/yv4tj29bt9tpTA08/7v/xNnSwWtiXdZJbPOq+fX5RqmpTWnXhy/MKzxdNKda+vut0W
	1nXKZK1mRBxPpK7NzrDogj5bzxmxu2efcp1cfF4jf0r1CyaXl9GRYueNH0hIeyZ+S54oH77L
	2nOhp7FDyqEjLpqbNnIosRRnJBpqMRcVJwIAglapXPgCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Lee Jones,


2014년 09월 16일 08:00에 Lee Jones 이(가) 쓴 글:
> On Thu, 11 Sep 2014, Jaewon Kim wrote:
>
>> This patch add haptic DT binding documentation and example
>> to support haptic driver in max77693 Multifunction device.
>>
>> Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
>> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>>   Documentation/devicetree/bindings/mfd/max77693.txt |   18 ++++++++++++++++++
>>   1 file changed, 18 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
>> index 11921cc..d178b9e 100644
>> --- a/Documentation/devicetree/bindings/mfd/max77693.txt
>> +++ b/Documentation/devicetree/bindings/mfd/max77693.txt
>> @@ -27,6 +27,17 @@ Optional properties:
>>   
>>   	[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
>>   
>> +- haptic : The haptic of max77693 have to be instantiated under subnod
> Perhaps a description as to what "The haptic" is might be handy?
Ok, I will add description about haptic.

>
> s/have/has
>
> s/subnod/subnode
>
> What do you mean by "under" a subnode?  Do you mean "as a" subnode?
>
>> +  named "haptic" using the following haptic format in example.
> What is the "haptic format"?  It just looks like a normal node to me.
>
>> +  Haptic sensation from motor can be changed by changing a period cycle in pwms.
> Is "Haptic sensation" a technical term?
>
> s/from motor/from a motor/
>
> s/changed by changing/changed by varying/
>
> s/period cycle/duty cycle/
>
> s/in pwms/in the pwms property/
How is it if I change in this way?

haptic : Referring to the term Haptic, It is the use of advanced 
vibration patterns
     and waveforms to convey information to a user or operator.

     MAX77693 uses PWM and MOTOR in order to give Haptic.
     The Haptic from a motor can be changed by varying a period/duty 
cycle in pwms.

>
>> +
>> + Required properties:
>> +	- compatible : Must be "maxim,max77693-hpatic"
>> +	- haptic-supply : power supply for haptic motor
> s/for haptic/for the haptic/
>
>> +		[*] refer Documentation/devicetree/bindings/regulator/regulator.txt
>> +	- pwms : phandle to the physical PWM device,
> It's not just the phandle though is it?
Do you want more description?
Or it mean the wrong?

>
>> +		[*] refer Documentation/devicetree/bindings/pwm/pwm.txt
>> +
>>   Example:
>>   	max77693@66 {
>>   		compatible = "maxim,max77693";
>> @@ -52,4 +63,11 @@ Example:
>>   					regulator-boot-on;
>>   			};
>>   		};
>> +
>> +		haptic {
>> +			compatible = "maxim,max77693-haptic";
>> +			haptic-supply = <&haptic_supply>;
>> +			pwms = <&pwm 0 40000 0>;
>> +			pwm-names = "haptic";
>> +		};
>>   	};

Thank you for feedback.
And plz review "[PATCH v4 3/4] mfd: max77693: add haptic of_compatible 
in mfd_cell".

thanks.
