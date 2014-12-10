Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbaLJMl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 07:41:28 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:47137 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753573AbaLJMlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 07:41:25 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-78-54883f737b81
Message-id: <54883F71.5010803@samsung.com>
Date: Wed, 10 Dec 2014 13:41:21 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, cooloney@gmail.com, rpurdie@rpsys.net,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        Andrzej Hajda <a.hajda@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH/RFC v9 06/19] DT: Add documentation for the mfd Maxim
 max77693
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
 <1417622814-10845-7-git-send-email-j.anaszewski@samsung.com>
 <20141204100706.GP14746@valkosipuli.retiisi.org.uk>
 <54804840.4030202@samsung.com> <20141204161201.GB29080@amd>
 <54883A70.7070903@samsung.com>
In-reply-to: <54883A70.7070903@samsung.com>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFIsWRmVeSWpSXmKPExsVy+t/xK7rF9h0hBoc+y1ncWneO1WLjjPWs
	Fkd3TmSyuP7lOavF/CNAsf43C1ktzr1ayWhxtukNu8X9r0cZLS7vmsNmsfXNOkaLng1bWS2W
	Xr/IZHH31FE2iwnT17JYtO49wm6xe9dTVovDb9pZLc7sX8nmIOyxZt4aRo/Lfb1MHjtn3WX3
	WLn8C5vH4a8LWTw2repk87hzbQ+bx575P1g9+rasYvRYsfo7u8fnTXIB3FFcNimpOZllqUX6
	dglcGZfX3WMquCRc8fDGZZYGxmf8XYycHBICJhIN5y8wQdhiEhfurWfrYuTiEBJYyihxed9x
	VgjnI6PE1ZnXwKp4BbQktj5tYwSxWQRUJb6u+gdmswkYSvx88RqsRlQgQuLP6X2sEPWCEj8m
	32MBsUUE9CWWrLoItoFZoIFFYtGs/WwgCWGBEImt+0+zQGybwyTR9PUx2CROAW2JOz0fwTYw
	C9hKLHi/jgXClpfYvOYt8wRGgVlIlsxCUjYLSdkCRuZVjKKppckFxUnpuUZ6xYm5xaV56XrJ
	+bmbGCHx+XUH49JjVocYBTgYlXh4dyi2hQixJpYVV+YeYpTgYFYS4X0j2REixJuSWFmVWpQf
	X1Sak1p8iJGJg1OqgVHXbTvLa9HELXvEUxy/fveXNZK+qVk62UDrWWHULgFb5oADVRuOH455
	/e774WezVDzu7DGzdj90Mpsp3z2LUerVgaqY/XMeL/m07d4JO1OHky+mJpsdO3XWdW3HuutX
	Zc5Zvkz7tkZJoU7YdsOyVeweLWs1zdxVplUocijUeyvdPDRBxdbj1UUlluKMREMt5qLiRABz
	HACUrQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 01:20 PM, Sylwester Nawrocki wrote:
> Hi,
>
> On 04/12/14 17:12, Pavel Machek wrote:
>>>>> +- maxim,boost-mode :
>>>>>>>> +	In boost mode the device can produce up to 1.2A of total current
>>>>>>>> +	on both outputs. The maximum current on each output is reduced
>>>>>>>> +	to 625mA then. If there are two child led nodes defined then boost
>>>>>>>> +	is enabled by default.
>>>>>>>> +	Possible values:
>>>>>>>> +		MAX77693_LED_BOOST_OFF - no boost,
>>>>>>>> +		MAX77693_LED_BOOST_ADAPTIVE - adaptive mode,
>>>>>>>> +		MAX77693_LED_BOOST_FIXED - fixed mode.
>>>>>>>> +- maxim,boost-vout : Output voltage of the boost module in millivolts.
>>>>>>>> +- maxim,vsys-min : Low input voltage level in millivolts. Flash is not fired
>>>>>>>> +	if chip estimates that system voltage could drop below this level due
>>>>>>>> +	to flash power consumption.
>>>>>>>> +
>>>>>>>> +Required properties of the LED child node:
>>>>>>>> +- label : see Documentation/devicetree/bindings/leds/common.txt
>>>>>>>> +- maxim,fled_id : Identifier of the fled output the led is connected to;
>>>>>>
>>>>>> I'm pretty sure this will be needed for about every chip that can drive
>>>>>> multiple LEDs. Shouldn't it be documented in the generic documentation?
>>>>
>>>> OK.
>>
>> Well... "fled_id" is not exactly suitable name. On other busses, it
>> would be "reg = <1>"?
>
> I think we need to clarify what the LED device node subnodes really mean.
> I thought initially they describe a physical current output of the LED
> controller, but it turns out the subnode corresponds to a LED attached
> to the LED controller.  Since a LED can be connected to multiple outputs
> of the LED controller I think 'reg' property doesn't make sense here.
>
> Then presumably we should use a property in each subnode, telling which
> LED controller outputs a LED is connected to?
>
> For instance, if we assign numbers 0, 1 to FLED1, FLED2 outputs of
> MAX77693 and there is just one LED connected to those outputs we would
> have something like:
>
> max77693: led {
> 	compatible = "maxim,max77693-led";	
> 	...
> 	led1 {
> 		maxim,fled-sources = <0 1>;
> 		...
> 	};
> };
>
> Feel free to propose better name for the property, I guess we need to
> avoid "maxim,current-sources" due to ambiguity of the word "current".

For me this sounds reasonable. Moreover we will avoid the need for
address-cells and size-cells properties in the parent node.

Best Regards,
Jacek Anaszewski
