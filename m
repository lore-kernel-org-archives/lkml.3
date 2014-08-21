Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbaHUSbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 14:31:09 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58413 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759AbaHUSbG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 14:31:06 -0400
From: "Murphy, Dan" <dmurphy@ti.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] doc: dt/bindings: input: introduce TI DRV2667
 haptic driver description
Thread-Topic: [PATCH 1/2] doc: dt/bindings: input: introduce TI DRV2667
 haptic driver description
Thread-Index: AQHPvWxlh8T1IOIo2Uaji+p6cWyocw==
Date: Thu, 21 Aug 2014 18:30:40 +0000
Message-ID: <00FC9A978A94B7418C33AFAE8A35ED49DF0933@DFLE09.ent.ti.com>
References: <1408645143-25690-1-git-send-email-dmurphy@ti.com>
 <1408645143-25690-2-git-send-email-dmurphy@ti.com>
 <53F63A68.1080002@cogentembedded.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.170.170.90]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei

On 08/21/2014 01:29 PM, Sergei Shtylyov wrote:
> Hello.
> 
> On 08/21/2014 10:19 PM, Dan Murphy wrote:
> 
>> DRV2667 is a haptic/vibrator driver for Linear Resonant Actuators.
>> Adding dt binding for this part
> 
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
>>   .../devicetree/bindings/input/ti,drv2667.txt       |   18 ++++++++++++++++++
>>   1 file changed, 18 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/input/ti,drv2667.txt
> 
>> diff --git a/Documentation/devicetree/bindings/input/ti,drv2667.txt b/Documentation/devicetree/bindings/input/ti,drv2667.txt
>> new file mode 100644
>> index 0000000..525216d
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/input/ti,drv2667.txt
>> @@ -0,0 +1,18 @@
>> +Texas Instruments - drv2667 Haptics driver
>> +
>> +The drv2667 uses serial control bus communicates through I2C protocols
> 
>     I can't parse that.
> 

Hmmm.. It made sense when I typed it.  Will fix

>> +
>> +Required properties:
>> +	- compatible - "ti,drv2667" - DRV2667
>> +	- reg -  I2C slave address
>> +	- vbat-supply - Required supply regulator
>> +
>> +Example:
>> +
>> +drv2667: drv2667@59 {
>> +		compatible = "ti,drv2667";
>> +		reg = <0x59>;
> 
>     You say "vbat-supply" is mandatory, yet you don't have it in your example?

I will add this as well.

> 
> WBR, Sergei
> 
> 


-- 
------------------
Dan Murphy
