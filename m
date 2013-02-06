Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177Ab3BFJk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 04:40:58 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:39596 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276Ab3BFJkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 04:40:55 -0500
Message-ID: <51122521.2090506@atmel.com>
Date: Wed, 6 Feb 2013 10:40:49 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Yang, Wenyou" <Wenyou.Yang@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "richard.genoud@gmail.com" <richard.genoud@gmail.com>,
        "Lin, JM" <JM.Lin@atmel.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [v4 PATCH 11/12] ARM: dts: add spi nodes for atmel SoC
References: <1358148877-18679-1-git-send-email-wenyou.yang@atmel.com> <1358148877-18679-12-git-send-email-wenyou.yang@atmel.com> <20130205195126.GB30595@game.jcrosoft.org> <B256D81BAE5131468A838E5D7A2436413A086C1E@penmbx02>
In-Reply-To: <B256D81BAE5131468A838E5D7A2436413A086C1E@penmbx02>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2013 02:35 AM, Yang, Wenyou :
> 
> 
>> -----Original Message-----
>> From: Jean-Christophe PLAGNIOL-VILLARD [mailto:plagnioj@jcrosoft.com]
>> Sent: 2013Äê2ÔÂ6ÈÕ 3:51
>> To: Yang, Wenyou
>> Cc: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Ferre,
>> Nicolas; richard.genoud@gmail.com; Lin, JM; linux@arm.linux.org.uk
>> Subject: Re: [v4 PATCH 11/12] ARM: dts: add spi nodes for atmel SoC
>>
>> On 15:34 Mon 14 Jan     , Wenyou Yang wrote:
>>> From: Richard Genoud <richard.genoud@gmail.com>
>>>
>>> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
>>> [wenyou.yang@atmel.com: add spi nodes for sam9260, sam9263, sam9g45
>> and sam9n12]
>>> [wenyou.yang@atmel.com: remove spi property "cs-gpios" to the board dts
>> files]
>>> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
>>> Cc: linux@arm.linux.org.uk
>>> ---
>>>  arch/arm/boot/dts/at91sam9260.dtsi |   18 ++++++++++++++++++
>>>  arch/arm/boot/dts/at91sam9263.dtsi |   18 ++++++++++++++++++
>>>  arch/arm/boot/dts/at91sam9g45.dtsi |   18 ++++++++++++++++++
>> I alreadt have some patch in queue
>>
> Thanks
> I will remove this patch in the next version.

Well, I am not sure:
Jean Christophe, if the patches are in your own queue, I do not see why
this series has to be modified.

The "I already have a patch to address this" type of comment is not a
proper comment:
1/ either you already have submitted the patch (and the new series has
to take it into
   account, obviously)
2/ or the patch is not public yet and you now have to deal with this
series posted before
   your own one.
There is no a third way...

Best regards,

>>>  arch/arm/boot/dts/at91sam9n12.dtsi |   18 ++++++++++++++++++
>>>  arch/arm/boot/dts/at91sam9x5.dtsi  |   18 ++++++++++++++++++
>>>  5 files changed, 90 insertions(+)
>>>
>>> diff --git a/arch/arm/boot/dts/at91sam9260.dtsi
>> b/arch/arm/boot/dts/at91sam9260.dtsi
>>> index 68bccf4..9586fe1 100644
>>> --- a/arch/arm/boot/dts/at91sam9260.dtsi
>>> +++ b/arch/arm/boot/dts/at91sam9260.dtsi
>>> @@ -453,6 +453,24 @@
>>>  				status = "disabled";
>>>  			};
>>>
>>> +			spi0: spi@fffc8000 {
>>> +				#address-cells = <1>;
>>> +				#size-cells = <0>;
>>> +				compatible = "atmel,at91sam9260-spi";
>>> +				reg = <0xfffc8000 0x200>;
>>> +				interrupts = <12 4 3>;
>>> +				status = "disabled";
>>> +			};
>>> +
>>> +			spi1: spi@fffcc000 {
>>> +				#address-cells = <1>;
>>> +				#size-cells = <0>;
>>> +				compatible = "atmel,at91sam9260-spi";
>>> +				reg = <0xfffcc000 0x200>;
>>> +				interrupts = <13 4 3>;
>>> +				status = "disabled";
>>> +			};
>>> +
>>>  			adc0: adc@fffe0000 {
>>>  				compatible = "atmel,at91sam9260-adc";
>>>  				reg = <0xfffe0000 0x100>;
>>> diff --git a/arch/arm/boot/dts/at91sam9263.dtsi
>> b/arch/arm/boot/dts/at91sam9263.dtsi
>>> index 32ec62c..636b882 100644
>>> --- a/arch/arm/boot/dts/at91sam9263.dtsi
>>> +++ b/arch/arm/boot/dts/at91sam9263.dtsi
>>> @@ -426,6 +426,24 @@
>>>  				reg = <0xfffffd40 0x10>;
>>>  				status = "disabled";
>>>  			};
>>> +
>>> +			spi0: spi@fffa4000 {
>>> +				#address-cells = <1>;
>>> +				#size-cells = <0>;
>>> +				compatible = "atmel,at91sam9260-spi";
>>> +				reg = <0xfffa4000 0x200>;
>>> +				interrupts = <14 4 3>;
>>> +				status = "disabled";
>>> +			};
>>> +
>>> +			spi1: spi@fffa8000 {
>>> +				#address-cells = <1>;
>>> +				#size-cells = <0>;
>>> +				compatible = "atmel,at91sam9260-spi";
>>> +				reg = <0xfffa8000 0x200>;
>>> +				interrupts = <15 4 3>;
>>> +				status = "disabled";
>>> +			};
>>>  		};
>>>
>>>  		nand0: nand@40000000 {
>>> diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi
>> b/arch/arm/boot/dts/at91sam9g45.dtsi
>>> index 231858f..0100b80 100644
>>> --- a/arch/arm/boot/dts/at91sam9g45.dtsi
>>> +++ b/arch/arm/boot/dts/at91sam9g45.dtsi
>>> @@ -495,6 +495,24 @@
>>>  				reg = <0xfffffd40 0x10>;
>>>  				status = "disabled";
>>>  			};
>>> +
>>> +			spi0: spi@fffa4000 {
>>> +				#address-cells = <1>;
>>> +				#size-cells = <0>;
>>> +				compatible = "atmel,at91sam9g45-spi";
>>> +				reg = <0xfffa4000 0x200>;
>>> +				interrupts = <14 4 3>;
>>> +				status = "disabled";
>>> +			};
>>> +
>>> +			spi1: spi@fffa8000 {
>>> +				#address-cells = <1>;
>>> +				#size-cells = <0>;
>>> +				compatible = "atmel,at91sam9g45-spi";
>>> +				reg = <0xfffa8000 0x200>;
>>> +				interrupts = <15 4 3>;
>>> +				status = "disabled";
>>> +			};
>>>  		};
>>>
>>>  		nand0: nand@40000000 {
>>> diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi
>> b/arch/arm/boot/dts/at91sam9n12.dtsi
>>> index e9efb34..86d5357 100644
>>> --- a/arch/arm/boot/dts/at91sam9n12.dtsi
>>> +++ b/arch/arm/boot/dts/at91sam9n12.dtsi
>>> @@ -355,6 +355,24 @@
>>>  				#size-cells = <0>;
>>>  				status = "disabled";
>>>  			};
>>> +
>>> +			spi0: spi@f0000000 {
>>> +				#address-cells = <1>;
>>> +				#size-cells = <0>;
>>> +				compatible = "atmel,at91sam9x5-spi";
>>> +				reg = <0xf0000000 0x100>;
>>> +				interrupts = <13 4 3>;
>>> +				status = "disabled";
>>> +			};
>>> +
>>> +			spi1: spi@f0004000 {
>>> +				#address-cells = <1>;
>>> +				#size-cells = <0>;
>>> +				compatible = "atmel,at91sam9x5-spi";
>>> +				reg = <0xf0004000 0x100>;
>>> +				interrupts = <14 4 3>;
>>> +				status = "disabled";
>>> +			};
>>>  		};
>>>
>>>  		nand0: nand@40000000 {
>>> diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi
>> b/arch/arm/boot/dts/at91sam9x5.dtsi
>>> index 40ac3a4..8ea2f7d 100644
>>> --- a/arch/arm/boot/dts/at91sam9x5.dtsi
>>> +++ b/arch/arm/boot/dts/at91sam9x5.dtsi
>>> @@ -473,6 +473,24 @@
>>>  					trigger-value = <0x6>;
>>>  				};
>>>  			};
>>> +
>>> +			spi0: spi@f0000000 {
>>> +				#address-cells = <1>;
>>> +				#size-cells = <0>;
>>> +				compatible = "atmel,at91sam9x5-spi";
>>> +				reg = <0xf0000000 0x100>;
>>> +				interrupts = <13 4 3>;
>>> +				status = "disabled";
>>> +			};
>>> +
>>> +			spi1: spi@f0004000 {
>>> +				#address-cells = <1>;
>>> +				#size-cells = <0>;
>>> +				compatible = "atmel,at91sam9x5-spi";
>>> +				reg = <0xf0004000 0x100>;
>>> +				interrupts = <14 4 3>;
>>> +				status = "disabled";
>>> +			};
>>>  		};
>>>
>>>  		nand0: nand@40000000 {
>>> --
>>> 1.7.9.5
>>>
> 
> Best Regards,
> Wenyou Yang
> 


-- 
Nicolas Ferre
