Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbaKRKFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:05:11 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30369 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbaKRKFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:05:00 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-c0-546b19c91bf9
Message-id: <546B19C8.2090008@samsung.com>
Date: Tue, 18 Nov 2014 11:04:56 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, pali.rohar@gmail.com, sre@debian.org,
        sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, bcousson@baylibre.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC] adp1653: Add device tree bindings for LED controller
References: <20141116075928.GA9763@amd>
 <20141117145857.GO8907@valkosipuli.retiisi.org.uk>
 <546AFEA5.9020000@samsung.com> <20141118084603.GC4059@amd>
In-reply-to: <20141118084603.GC4059@amd>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsVy+t/xy7onJbNDDP7+NLdY88LB4s78v6wW
	84+cY7V4/FXPov/NQlaLc69WMlo83fyYyWLT42usFpd3zWGz6NmwldVi9pJ+Foul1y8yWUw8
	/ZvJ4u6po2wWE6avZbFo3XuE3eLM/pVsFq/vPGKyWP4pwmL/FS8HEY+j51+xeqyZt4bR49vX
	SSwe72+0sntc7utl8vjVNpfZY+esu+weK5d/YfM4/HUhi8emVZ1sHpuX1HvsPfSD3WPF6u/s
	Hp83yQXwRXHZpKTmZJalFunbJXBlfL5yhLngn2rFp2fnGRsYJ8l1MXJwSAiYSFx7UNTFyAlk
	iklcuLeerYuRi0NIYCmjxLdvjUwgCSGBj4wS72eZgNTzCmhJvJ4sDhJmEVCV+Nf1gBHEZhMw
	lPj54jVYuahAhMSf0/tYQWxeAUGJH5PvsYDYIgLyElv7VjCDzGcW+Mcs0Xy1B6xBWMBdYuaN
	S+wQu2YySsxpFAOxOQU0JI4emQ7WzCxgLbFy0jZGCFteYvOat8wTGAVmIdkxC0nZLCRlCxiZ
	VzGKppYmFxQnpeca6RUn5haX5qXrJefnbmKERO3XHYxLj1kdYhTgYFTi4W3YmBUixJpYVlyZ
	e4hRgoNZSYT3XDdQiDclsbIqtSg/vqg0J7X4ECMTB6dUA6Nf+II132oOGO8R9+i/PJv5wAEF
	H/udhdO2FPJ8j+iXPcsTq75bSGXmGU/bPYxrjXrZxHYGRAXph8xWZtr/R980QpiNdddk3uj4
	6d7fi5c5XpWV+pP20yzselzN8iPOGd6clnvt5FKXpCSkVnyy2uHb9PzC5NKVNxeF5nAx8ay9
	Hh5prH9/qhJLcUaioRZzUXEiAFTut+m4AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2014 09:46 AM, Pavel Machek wrote:
> On Tue 2014-11-18 09:09:09, Jacek Anaszewski wrote:
>> Hi Pavel, Sakari,
>>
>> On 11/17/2014 03:58 PM, Sakari Ailus wrote:
>>> Hi Pavel,
>>>
>>> On Sun, Nov 16, 2014 at 08:59:28AM +0100, Pavel Machek wrote:
>>>> For device tree people: Yes, I know I'll have to create file in
>>>> documentation, but does the binding below look acceptable?
>>>>
>>>> I'll clean up driver code a bit more, remove the printks. Anything
>>>> else obviously wrong?
>>>
>>> Jacek Anaszewski is working on flash support for LED devices. I think it'd
>>> be good to sync the DT bindings for the two, as the types of devices
>>> supported by the LED API and the V4L2 flash API are quite similar.
>>>
>>> Cc Jacek.
>>
>> I've already submitted a patch [1] that updates leds common bindings.
>> I hasn't been merged yet, as the related LED Flash class patch [2]
>> still needs some indicator leds related discussion [3].
>>
>> I think this is a good moment to discuss the flash related led common
>> bindings.
>
> Part of problem is that adp1653 is not regarded as "LED" device by
> current kernel driver.

It doesn't prevent us from keeping the flash devices related
DT bindings unified across kernel subsystems. The DT bindings
docs for the adp1653 could just provide a reference to the
led/common.txt bindings. In the future, when LED Flash
class will be merged, all the V4L2 Flash drivers might be
moved to the LED subsystem to gain the LED subsystem support.

>> [1] http://www.spinics.net/lists/linux-leds/msg02121.html
>
> @@ -3,6 +3,17 @@ Common leds properties.
>   Optional properties for child nodes:
>   - label : The label for this LED.  If omitted, the label is
>     taken from the node name (excluding the unit address).
> +- iout-torch : Array of maximum intensities in microamperes of the
>   torch
> +	led currents in order from sub-led 0 to N-1, where N is the
>   number
> +	of torch sub-leds exposed by the device
> +- iout-flash : Array of maximum intensities in microamperes of the
>   flash
> +	led currents in order from sub-led 0 to N-1, where N is the
>   number
> +	of flash sub-leds exposed by the device
> +- iout-indicator : Array of maximum intensities in microamperes of
> +  the indicator led currents in order from sub-led 0 to N-1,
> +  where N is the number of indicator sub-leds exposed by the device
> +- flash-timeout : timeout in microseconds after which flash led
> +  is turned off
>
>   - linux,default-trigger :  This parameter, if present, is a
>       string defining the trigger assigned to the LED.  Current
>       triggers are:
> @@ -19,5 +30,10 @@ Examples:
>   system-status {
>   	       label = "Status";
>   	       linux,default-trigger = "heartbeat";
> +	       iout-torch = <500 500>;
> +	       iout-flash = <1000 1000>;
> +	       iout-indicator = <100 100>;
> +	       flash-timeout = <1000>;
> +
> 	...
>   };
>
> I don't get it; system-status describes single LED, why are iout-torch
> (and friends) arrays of two?

Some devices can control more than one led. The array is for such
purposes. The system-status should be probably renamed to
something more generic for both common leds and flash leds,
e.g. system-led.

> Also, at least on adp1653, these are actually two leds -- white and
> red. Torch and flash is white led, indicator is red led.

Then you should define three properties:

iout-torch = <[uA]>;
iout-flash = <[uA]>;
iout-indicator = <[uA]>;

iout-torch and iout-flash properties would determine the current
for the white led in the torch and flash modes respectively and
the iout-indicator property would determine the current for
the indicator led.

>> [2] http://www.spinics.net/lists/linux-media/msg83100.html
>> [3] http://www.spinics.net/lists/linux-leds/msg02472.html
>
> What device are you using for testing? Can you cc me on future
> patches?

I am using max77693 [1] and aat1290 [2]. OK, I will add you on cc.

> Why do we need complex "flash LED class" support, and where is the
> V4L2 glue?

The rationale for unification of the LED and V4L2 Flash API
can be found in the discussion [3]. The glue is the v4l2-flash [4]
module which exposes a sub-device, that controls a LED Flash class
device with use of LED Flash class API.

The v4l2-flash sub-device registers with v4l2-async API
in a media device. Exemplary support for v4l2-flash
sub-devices is added to the exynos4-is driver in the patch [5].

Best Regards,
Jacek Anaszewski

[1] http://www.spinics.net/lists/linux-leds/msg02326.html
[2] http://www.spinics.net/lists/linux-media/msg81079.html
[3] http://www.spinics.net/lists/linux-media/msg69012.html
[4] http://www.spinics.net/lists/linux-leds/msg02322.html
[5] http://www.spinics.net/lists/linux-leds/msg02323.html

