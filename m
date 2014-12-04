Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbaLDLk4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 06:40:56 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:29642 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbaLDLkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 06:40:53 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-ac-548048425d76
Message-id: <54804840.4030202@samsung.com>
Date: Thu, 04 Dec 2014 12:40:48 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, s.nawrocki@samsung.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        Andrzej Hajda <a.hajda@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH/RFC v9 06/19] DT: Add documentation for the mfd Maxim
 max77693
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
 <1417622814-10845-7-git-send-email-j.anaszewski@samsung.com>
 <20141204100706.GP14746@valkosipuli.retiisi.org.uk>
In-reply-to: <20141204100706.GP14746@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsVy+t/xy7pOHg0hBn19cha31p1jtdg4Yz2r
	xdGdE5ksrn95zmox/whQrP/NQlaLc69WMlqcbXrDbnH/61FGi8u75rBZbH2zjtGiZ8NWVoul
	1y8yWdw9dZTNYsL0tSwWrXuPsFvs3vWU1eLwm3ZWizP7V7I5CHusmbeG0eNyXy+Tx85Zd9k9
	Vi7/wuZx+OtCFo9NqzrZPO5c28PmsWf+D1aPvi2rGD1WrP7O7vF5k1wAdxSXTUpqTmZZapG+
	XQJXxtrPHSwFC40rfh5+yNzAOEGzi5GTQ0LAROLbq2UsELaYxIV769m6GLk4hASWMko0v7rA
	CuF8ZJR4tXcDO0gVr4CWRMPJ42AdLAKqEv/n3Qaz2QQMJX6+eM0EYosKREj8Ob2PFaJeUOLH
	5HtgNSICahJPNz1kARnKLPCYWaJt5WqwImGBEImt+0+zQGzbyyjx7Nt7ZpAEp4CDRPOuZYwg
	NrOAtcTKSdugbHmJzWveMk9gFJiFZMksJGWzkJQtYGRexSiaWppcUJyUnmukV5yYW1yal66X
	nJ+7iRESn193MC49ZnWIUYCDUYmHd8L1+hAh1sSy4srcQ4wSHMxKIrynrBtChHhTEiurUovy
	44tKc1KLDzEycXBKNTDG3qqWDZmltubr/77WuGh5y927jc1NBUtyS5do9c1lX2AUrnjpwj61
	jatmf+BuuXLrz0PrWU4CjI84d+wW/ijSyMcW3b/0f0Om7KPovz/b/2wNX7nreyV30/rbDNU9
	MXrH765NuX+YXy3H41vllzOhbB7rcgOdJxfb/rKYnP9p+3I1zmJjno9KLMUZiYZazEXFiQAy
	JixorQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari,

Thanks for the review.

On 12/04/2014 11:07 AM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Wed, Dec 03, 2014 at 05:06:41PM +0100, Jacek Anaszewski wrote:
>> This patch adds device tree binding documentation for
>> the flash cell of the Maxim max77693 multifunctional device.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Lee Jones <lee.jones@linaro.org>
>> Cc: Chanwoo Choi <cw00.choi@samsung.com>
>> Cc: Bryan Wu <cooloney@gmail.com>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Cc: Pawel Moll <pawel.moll@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
>> Cc: Kumar Gala <galak@codeaurora.org>
>> Cc: <devicetree@vger.kernel.org>
>> ---
>>   Documentation/devicetree/bindings/mfd/max77693.txt |   89 ++++++++++++++++++++
>>   1 file changed, 89 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
>> index 01e9f30..25a6e78 100644
>> --- a/Documentation/devicetree/bindings/mfd/max77693.txt
>> +++ b/Documentation/devicetree/bindings/mfd/max77693.txt
>> @@ -41,7 +41,66 @@ Optional properties:
>>   	 To get more informations, please refer to documentaion.
>>   	[*] refer Documentation/devicetree/bindings/pwm/pwm.txt
>>
>> +- led : the LED submodule device node
>> +
>> +There are two led outputs available - fled1 and fled2. Each of them can
>> +control a separate led or they can be connected together to double
>> +the maximum current for a single connected led. One led is represented
>> +by one child node.
>> +
>> +Required properties:
>> +- compatible : Must be "maxim,max77693-led".
>> +
>> +Optional properties:
>> +- maxim,fleds : Array of current outputs in order: fled1, fled2.
>> +	Note: both current outputs can be connected to a single led
>> +	Possible values:
>> +		MAX77693_LED_FLED_UNUSED - the output is left disconnected,
>> +		MAX77693_LED_FLED_USED - a diode is connected to the output.
>
> As you have a LED sub-nodes for each LED already, isn't this redundant?

Well, it seems so :)

>> +- maxim,trigger-type : Array of trigger types in order: flash, torch.
>> +	Possible trigger types:
>> +		MAX77693_LED_TRIG_TYPE_EDGE - Rising edge of the signal triggers
>> +			the flash/torch,
>> +		MAX77693_LED_TRIG_TYPE_LEVEL - Signal level controls duration of
>
> How about: "Strobe pulse length ..."?

OK, it will be more clear.

> How long does the torch stay on if you use edge trigger for it? I've always
> thought the torch enable pin was a practical joke. :-)

There is a torch timer available but I don't expose it to the user.

> If you need it this for torch as well, I'd use separate properties for the
> purpose, i.e. trigger-type-flash and trigger-type-torch.

OK.

>> +			the flash/torch.
>> +- maxim,trigger : Array of flags indicating which trigger can activate given led
>> +	in order: fled1, fled2.
>> +	Possible flag values (can be combined):
>> +		MAX77693_LED_TRIG_FLASHEN - FLASHEN pin of the chip,
>> +		MAX77693_LED_TRIG_TORCHEN - TORCHEN pin of the chip,
>> +		MAX77693_LED_TRIG_SOFTWARE - software via I2C command.
>
> Is there a need to prevent strobing using a certain method? Just wondering.

In some cases it could be convenient to prevent some options through
device tree.

>> +- maxim,boost-mode :
>> +	In boost mode the device can produce up to 1.2A of total current
>> +	on both outputs. The maximum current on each output is reduced
>> +	to 625mA then. If there are two child led nodes defined then boost
>> +	is enabled by default.
>> +	Possible values:
>> +		MAX77693_LED_BOOST_OFF - no boost,
>> +		MAX77693_LED_BOOST_ADAPTIVE - adaptive mode,
>> +		MAX77693_LED_BOOST_FIXED - fixed mode.
>> +- maxim,boost-vout : Output voltage of the boost module in millivolts.
>> +- maxim,vsys-min : Low input voltage level in millivolts. Flash is not fired
>> +	if chip estimates that system voltage could drop below this level due
>> +	to flash power consumption.
>> +
>> +Required properties of the LED child node:
>> +- label : see Documentation/devicetree/bindings/leds/common.txt
>> +- maxim,fled_id : Identifier of the fled output the led is connected to;
>
> I'm pretty sure this will be needed for about every chip that can drive
> multiple LEDs. Shouldn't it be documented in the generic documentation?

OK.

>> +		MAX77693_LED_FLED1 - FLED1 output of the device - it has to be
>> +			used also if a single LED is connected to both outputs,
>> +		MAX77693_LED_FLED2 - FLED2 output of the device.
>> +
>> +Optional properties of the LED child node:
>> +- max-microamp : see Documentation/devicetree/bindings/leds/common.txt
>> +		Range: 15625 - 250000
>> +- flash-max-microamp : see Documentation/devicetree/bindings/leds/common.txt
>> +		Range: 15625 - 1000000
>> +- flash-timeout-microsec : see Documentation/devicetree/bindings/leds/common.txt
>> +		Range: 62500 - 1000000
>> +
>>   Example:
>> +#include <dt-bindings/mfd/max77693.h>
>> +
>>   	max77693@66 {
>>   		compatible = "maxim,max77693";
>>   		reg = <0x66>;
>> @@ -73,4 +132,34 @@ Example:
>>   			pwms = <&pwm 0 40000 0>;
>>   			pwm-names = "haptic";
>>   		};
>> +
>> +		led {
>> +			compatible = "maxim,max77693-led";
>> +			maxim,fleds = <MAX77693_LED_FLED_USED
>> +				       MAX77693_LED_FLED_USED>;
>> +			maxim,trigger = <MAX77693_LED_TRIG_ALL
>> +					 (MAX77693_LED_TRIG_TORCHEN |
>> +					 MAX77693_LED_TRIG_SOFTWARE)>;
>> +			maxim,trigger-type = <MAX77693_LED_TRIG_TYPE_EDGE
>> +					      MAX77693_LED_TRIG_TYPE_LEVEL>;
>> +			maxim,boost-mode = <MAX77693_LED_BOOST_ADAPTIVE>;
>> +			maxim,boost-vout = <5000>;
>> +			maxim,vsys-min = <2400>;
>> +
>> +			camera1_flash: led1 {
>> +				maxim,fled_id = <MAX77693_LED_FLED1>;
>> +				label = "max77693-flash1";
>> +				max-microamp = <250000>;
>> +				flash-max-microamp = <625000>;
>> +				flash-timeout-microsec = <1000000>;
>> +			};
>> +
>> +			camera2_flash: led2 {
>> +				maxim,fled_id = <MAX77693_LED_FLED2>;
>> +				label = "max77693-flash2";
>> +				max-microamp = <250000>;
>> +				flash-max-microamp = <500000>;
>> +				flash-timeout-microsec = <1000000>;
>> +			};
>> +		};
>
> I like how this looks like in general.

Nice :)

>>   	};
>

Best Regards,
Jacek Anaszewski
