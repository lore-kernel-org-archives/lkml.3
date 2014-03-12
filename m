Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbaCLGCD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 02:02:03 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:63600 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902AbaCLGB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 02:01:57 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-51-531ff8530cc7
Message-id: <531FF852.8090502@samsung.com>
Date: Wed, 12 Mar 2014 15:01:54 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Tomasz Figa <t.figa@samsung.com>
Cc: kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        linux@arm.linux.org.uk
Subject: Re: [PATCH 5/5] ARM: dts: exynos4412-trats2: Add ADC's dt data to get
 temperature of SoC/battery
References: <1394524494-30641-1-git-send-email-cw00.choi@samsung.com>
 <1394524494-30641-6-git-send-email-cw00.choi@samsung.com>
 <531F0AEC.7010606@samsung.com>
In-reply-to: <531F0AEC.7010606@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsWyRsSkUDf4h3ywwcXfghbzj5xjtTj3aiWj
	Re+Cq2wWZ5vesFtsenyN1eLyrjlsFjPO72OyuH2Z12Lp9YtMFhOmr2WxOLziAJPFq4NtLBbr
	Z7xmceD1WDNvDaNHS3MPm8eCz1fYPVYu/8LmsXlJvUffllWMHp83yXlsnBsawBHFZZOSmpNZ
	llqkb5fAlXHs4HfWgkmiFUs3TWJpYPzB38XIySEhYCLR2DeZFcIWk7hwbz1bFyMXh5DAUkaJ
	9wvWsMAUvd99jB0isYhRor/lMDNIQkjgFaPEjVNZIDavgJbEn5ePwOIsAqoST9/uYgKx2YDi
	+1/cYAOxRQXCJFZOv8ICUS8o8WPyPTBbREBF4vKp6YwgNrPABSaJPXuLQGxhgWyJmye/sMEt
	3vfsOFgRp4C2xJafU6EadCT2t05jg7DlJTavecsM0iAh0Moh8X7OFaiLBCS+TT4EtI0DKCEr
	sekAM8RnkhIHV9xgmcAoNgvJTbOQjJ2FZOwCRuZVjKKpBckFxUnpRYZ6xYm5xaV56XrJ+bmb
	GIHRfPrfs94djLcPWB9iTAZaOZFZSjQ5H5gM8kriDY3NjCxMTUyNjcwtzUgTVhLnTXqYFCQk
	kJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBcW/Jg2lizqo/JtyQTnV8XuIv8sZh7m7HO7vXpJwK
	yLkg6/mtc3r075NRVc5yF9i9/ufVdJm8lBOM1+/j6ruxo2XBkuKEvVz7j3hu1ImIPLbgTsdp
	071Jy15KrVEztuWavD7qzYrU2aflt2nP8LWOj5vkOuGF74lN3xaFXomQbhSeZTYj0yswV4ml
	OCPRUIu5qDgRAJsral/8AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsVy+t9jAd3gH/LBBg3zOCzmHznHanHu1UpG
	i94FV9kszja9YbfY9Pgaq8XlXXPYLGac38dkcfsyr8XS6xeZLCZMX8ticXjFASaLVwfbWCzW
	z3jN4sDrsWbeGkaPluYeNo8Fn6+we6xc/oXNY/OSeo++LasYPT5vkvPYODc0gCOqgdEmIzUx
	JbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB+hiJYWyxJxSoFBA
	YnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhDWPGsYPfWQsmiVYs3TSJpYHxB38XIyeHhICJ
	xPvdx9ghbDGJC/fWs3UxcnEICSxilOhvOcwMkhASeMUoceNUFojNK6Al8eflI7A4i4CqxNO3
	u5hAbDag+P4XN9hAbFGBMImV06+wQNQLSvyYfA/MFhFQkbh8ajojiM0scIFJYs/eIhBbWCBb
	4ubJLwiL9z07DlbEKaAtseXnVKgGHYn9rdPYIGx5ic1r3jJPYBSYhWTHLCRls5CULWBkXsUo
	mlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnCqeSe9gXNVgcYhRgINRiYd3oaZ8sBBrYllxZe4h
	RgkOZiUR3o8gId6UxMqq1KL8+KLSnNTiQ4zJwCCYyCwlmpwPTGN5JfGGxiZmRpZG5oYWRsbm
	pAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cBYsnTpjTX1Mw6kirM66+asEylPSFksed3t
	p73Vfk3HjXuajHZ2WU+++CVhrc+aVnN75YPiT64nRKzlmp+5kjP1XtLajx7cXZ1Zzzj3r6lo
	/GH9VPTF8z+ThU6bK6iJeV3ec0ew482jdCXzG9NPKtoERrekqqxtY3nMnjZnjj3b/Dvdp0Oz
	W+cpsRRnJBpqMRcVJwIAbIBZ8VkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

On 03/11/2014 10:09 PM, Tomasz Figa wrote:
> Hi Chanwoo,
> 
> On 11.03.2014 08:54, Chanwoo Choi wrote:
>> This patch use ADC to get the temperature of SoC/battery by using NTC thermistor
>> driver in hwmon. NTC thermistor driver covnvert ADC's raw data to temperature
>> by using following variables:
>>
>> - pullup-uv    : Voltage
>> - pullup-ohm   : Pull-up resistance
>> - pulldown-ohm : Pull-down resistance
>> - io-channels  : It means ADC channel.
>>
> 
> Those properties are well-defined in "ntc,ncp15wb473" DT bindings documentation. There is no need to repeat them here.
> 
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>>   arch/arm/boot/dts/exynos4412-trats2.dts | 21 +++++++++++++++++++++
>>   1 file changed, 21 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/exynos4412-trats2.dts b/arch/arm/boot/dts/exynos4412-trats2.dts
>> index 4f851cc..fc517c3 100644
>> --- a/arch/arm/boot/dts/exynos4412-trats2.dts
>> +++ b/arch/arm/boot/dts/exynos4412-trats2.dts
>> @@ -106,6 +106,27 @@
>>           };
>>       };
>>
>> +    adc: adc@126C0000 {
>> +        vdd-supply = <&ldo3_reg>;
>> +        status = "okay";
>> +
>> +        ncp15wb473@0 {
> 
> style: Nodes should have generic names, e.g. thermistor@0.
> 
> Also if node name is suffixed with @unit-address, then the node should have a reg property with its first entry corresponding to the unit-address. Now there is no physical unit-address definition for those thermistors, so they shouldn't use this naming pattern, but rather something like "thermistor-0" or "thermistor-ap".

OK I'll rename thermistor dt name.
> 
>> +            compatible = "ntc,ncp15wb473";
>> +            pullup-uv = <1800000>;     /* VCC_1.8V_AP */
>> +            pullup-ohm = <100000>;     /* 100K */
>> +            pulldown-ohm = <100000>; /* 100K */
>> +            io-channels = <&adc 1>;  /* AP temperature */
>> +        };
>> +
>> +        ncp15wb473@1 {
>> +            compatible = "ntc,ncp15wb473";
>> +            pullup-uv = <1800000>;     /* VCC_1.8V_AP */
>> +            pullup-ohm = <100000>;     /* 100K */
>> +            pulldown-ohm = <100000>; /* 100K */
>> +            io-channels = <&adc 2>;  /* Battery temperature */
>> +        };
> 
> Anyway, I don't think it is correct to place IIO consumers under IIO provider node, because IIO is not a control bus, but rather a resource provider, like GPIO, clock, etc. So both thermistor nodes should be placed outside the adc node. (They might be grouped in a simple-bus subnode, though, to improve readability.)

OK, I'll move ntc_thermistor node outside of ADC dt node.

Best Regards,
Chanwoo Choi
