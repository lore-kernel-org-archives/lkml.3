Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab3GVNyI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 09:54:08 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:1142 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab3GVNyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 09:54:05 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <51ED3971.905@broadcom.com>
Date: Mon, 22 Jul 2013 15:53:53 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Lee Jones" <lee.jones@linaro.org>
cc: "Christian Daudt" <csd@broadcom.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 05/22] ARM: dts: bcm281xx: Remove '0x's from
 BCM11351 BRT DTS file
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
 <1374490361-25769-5-git-send-email-lee.jones@linaro.org>
 <51ED2D90.4020209@broadcom.com> <20130722133852.GA26801@laptop>
In-Reply-To: <20130722133852.GA26801@laptop>
X-WSS-ID: 7DF3E71A31W54498238-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 03:38 PM, Lee Jones wrote:
> On Mon, 22 Jul 2013, Christian Daudt wrote:
>
>> On 13-07-22 03:52 AM, Lee Jones wrote:
>>> Cc: Christian Daudt <csd@broadcom.com>
>>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>> ---
>>>   arch/arm/boot/dts/bcm11351-brt.dts | 6 +++---
>>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/arm/boot/dts/bcm11351-brt.dts b/arch/arm/boot/dts/bcm11351-brt.dts
>>> index 67ec524..fdace5d 100644
>>> --- a/arch/arm/boot/dts/bcm11351-brt.dts
>>> +++ b/arch/arm/boot/dts/bcm11351-brt.dts
>>> @@ -27,18 +27,18 @@
>>>   		status = "okay";
>>>   	};
>>> -	sdio0: sdio@0x3f180000 {
>>> +	sdio0: sdio@3f180000 {
>>>   		max-frequency = <48000000>;
>>>   		status = "okay";
>>>   	};
>>> -	sdio1: sdio@0x3f190000 {
>>> +	sdio1: sdio@3f190000 {
>>>   		non-removable;
>>>   		max-frequency = <48000000>;
>>>   		status = "okay";
>>>   	};
>>> -	sdio3: sdio@0x3f1b0000 {
>>> +	sdio3: sdio@3f1b0000 {
>>>   		max-frequency = <48000000>;
>>>   		status = "okay";
>>>   	};
>> Hi Lee,
>>   Is this convention documented ? Someone called my attention to the
>> fact that this dts files was inconsistent in its use of 0x in names,
>> but I was not aware of a coding guideline for this.
>
> The best two places I can think of are:
>
> Documentation/devicetree/usage-model.txt
> and
> http://www.devicetree.org/Device_Tree_Usage

And even those do not stick to a single convention, but that is what can 
be expected of a twiki page :-p

Regards,
Arend


