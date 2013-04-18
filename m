Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab3DRSbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 14:31:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36954 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873Ab3DRSbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 14:31:15 -0400
Message-ID: <51703BEF.6050804@ti.com>
Date: Thu, 18 Apr 2013 13:31:11 -0500
From: Dan Murphy <dmurphy@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Vincent_Stehl=E9?= <v-stehle@ti.com>
CC: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] ARM:dts:omap4-panda:Update the LED support for the
 panda DTS
References: <1366229760-4808-1-git-send-email-dmurphy@ti.com> <516FBD18.3060501@ti.com>
In-Reply-To: <516FBD18.3060501@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2013 04:30 AM, Vincent Stehlé wrote:
> On 04/17/2013 10:16 PM, Dan Murphy wrote:
>> The GPIO for LED D1 on the omap4-panda a1-a3 rev and the omap4-panda-es
>> are different.
> (..)
>> diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
>> index 03bd60d..0c48f6b 100644
>> --- a/arch/arm/boot/dts/omap4-panda-common.dtsi
>> +++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
> (..)
>> @@ -135,6 +136,25 @@
>>   			0xf0 0x118     /* i2c4_sda PULLUP | INPUTENABLE | MODE0 */
>>   		>;
>>   	};
>> +
>> +	led_gpio_pins: pinmux_leds_pins {
>> +		pinctrl-single,pins = <
>> +		>;
>> +	};
>> +};
> Hi,
>
> FYI, there was a recent discussion precisely on this topic, where Tomy
> suggested to remove the empty section:
> http://marc.info/?l=linux-omap&m=136546635409232&w=2
>
> Apart from that, I just tested your patch on top of Tomy's
> omap-for-v3.10/dt branch and it is working fine for me on PandaBoards
> EA3, A4 and ES.
>
> Tested-by: Vincent Stehlé <v-stehle@ti.com>
>
> Best regards,
>
> V.
>
Thanks for testing Vincent

Is there a way to append the data to an already existing node?
I do not see a clean way.

Dan

-- 
----------------------------------------------
Dan Murphy

