Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbaHVOZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:25:38 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44941 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756319AbaHVOZg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:25:36 -0400
From: "Murphy, Dan" <dmurphy@ti.com>
To: "Balbi, Felipe" <balbi@ti.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] doc: dt/bindings: input: Fix drv260x binding document
Thread-Topic: [PATCH] doc: dt/bindings: input: Fix drv260x binding document
Thread-Index: AQHPvhMXmuDbV0D58UmgOrd6qfqhIg==
Date: Fri, 22 Aug 2014 14:25:13 +0000
Message-ID: <00FC9A978A94B7418C33AFAE8A35ED49DF1F66@DFLE09.ent.ti.com>
References: <1408716741-1163-1-git-send-email-dmurphy@ti.com>
 <20140822141532.GC22707@saruman.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe

On 08/22/2014 09:15 AM, Balbi, Felipe wrote:
> On Fri, Aug 22, 2014 at 09:12:21AM -0500, Dan Murphy wrote:
>> Update the drv260x dt binding document:
>> - Change the node name to the devices function not the
>> device name.
>> - Add vbat-supply to the example.
>> - Fix indentation of the example.
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
>>  .../devicetree/bindings/input/ti,drv260x.txt       |   19 ++++++++++---------
>>  1 file changed, 10 insertions(+), 9 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/input/ti,drv260x.txt b/Documentation/devicetree/bindings/input/ti,drv260x.txt
>> index a9c8519..214e25d 100644
>> --- a/Documentation/devicetree/bindings/input/ti,drv260x.txt
>> +++ b/Documentation/devicetree/bindings/input/ti,drv260x.txt
>> @@ -37,15 +37,16 @@ Optional properties:
>>  			  3.2 v.
>>  Example:
>>  
>> -drv2605l: drv2605l@5a {
>> -		compatible = "ti,drv2605l";
>> -		reg = <0x5a>;
>> -		enable-gpio = <&gpio1 28 GPIO_ACTIVE_HIGH>;
>> -		mode = <DRV260X_LRA_MODE>;
>> -		library-sel = <DRV260X_LIB_LRA>;
>> -		vib-rated-mv = <3200>;
>> -		vib-overdriver-mv = <3200>;
>> -};
>> +haptics:@5a {
> 
> haptics: haptics@5a ??
> 

I found both types of entries in the bindings docs.

There is no consistency within the input bindings documentation.

I have no issue doing it either way.

Dan

-- 
------------------
Dan Murphy
