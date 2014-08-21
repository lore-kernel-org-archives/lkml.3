Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbaHUKcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 06:32:53 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29778 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbaHUKcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 06:32:50 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-c9-53f5cacf8237
Message-id: <53F5CACB.5010706@samsung.com>
Date: Thu, 21 Aug 2014 12:32:43 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
Newsgroups: gmane.comp.video.dri.devel,gmane.linux.pwm,gmane.linux.drivers.devicetree,gmane.linux.kernel,gmane.linux.ports.arm.kernel
To: Thierry Reding <thierry.reding@gmail.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-pwm@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <pawel.moll@arm.com>,
        devicetree@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Rob Herring <robh+dt@kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Bo Shen <voice.shen@atmel.com>, Kumar Gala <galak@codeaurora.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 00/11] drm: add support for Atmel HLCDC Display
 Controller
References: <1406034695-15534-1-git-send-email-boris.brezillon@free-electrons.com>
 <20140821081619.GZ2452@ldesroches-Latitude-E6320>
 <20140821103706.2349915d@bbrezillon> <20140821090406.GA13733@ulmo>
 <20140821114159.319e741b@bbrezillon> <20140821095202.GA21848@ulmo>
In-reply-to: <20140821095202.GA21848@ulmo>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t/xa7rnT30NNvh4msWi49piJosDLxay
	WMw/co7V4srX92wW/W8Wslqce7WS0aJz4hJ2i/tfjzJabHp8jdXi8q45bBZ3765itFi+4imz
	xaGZyRZLr19ksvh2uZndYsL0tSwW6x6+YLJo3XuE3eJ0N6vFz13zWCwmTtvK6CDqsWbeGkaP
	Bb+2snhc7utl8niy6SKjx85Zd9k9Vi7/wuYxu2Mmq8erC3dYPDat6mTzuHNtD5vHvJOBHve7
	jzN5bF5S7zHx9jQWj8+b5AL4o7hsUlJzMstSi/TtErgylmxcxlwwTanixYwljA2MF6S7GDk4
	JARMJN7dl+1i5AQyxSQu3FvP1sXIxSEksJRR4ufe/ywQzidGiQudt1hAqngFtCQu/X4NZrMI
	qEpMevMDzGYT0JT4u/kmG4gtKhAm8ezXQSaIekGJH5PvgQ3iE2hnlGhZOhmsQUQgVeJv0yOw
	BLPAX1aJzfvOgHUICwRLNH7bCLV6EpPE1tetYGM5gVY3TpvNDHI3s4CexP2LWiBhZgF5ic1r
	3jJPYBSchWThLISqWUiqFjAyr2IUTS1NLihOSs810itOzC0uzUvXS87P3cQIifOvOxiXHrM6
	xCjAwajEw3tz0ZdgIdbEsuLK3EOMEhzMSiK8mbu/BgvxpiRWVqUW5ccXleakFh9iZOLglGpg
	PJF5Wn8P1859Eh3vuxR3ei++WvM9p/OA1oNFZ/g3OiTE7Mu3jvNXWnRrqpqSgCrXpLZKliRX
	f6kXs78dVpxuW6C9OFt56qfDS9YtnnSMx577jqNm6SHGWQ83XJXijFr6OodH5J3sZh0dY9/6
	xIXrV8ombGP4//TwcU5eK6bYad3hO0SDnSL3KbEUZyQaajEXFScCAOYYO2DRAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2014 11:52 AM, Thierry Reding wrote:
> On Thu, Aug 21, 2014 at 11:41:59AM +0200, Boris BREZILLON wrote:
>> On Thu, 21 Aug 2014 11:04:07 +0200
>> Thierry Reding <thierry.reding@gmail.com> wrote:
>>
>>> On Thu, Aug 21, 2014 at 10:37:06AM +0200, Boris BREZILLON wrote:
>>>> Hi Ludovic,
>>>>
>>>> On Thu, 21 Aug 2014 10:16:19 +0200
>>>> Ludovic Desroches <ludovic.desroches@atmel.com> wrote:
>>>>
>>>>> Hi Boris,
>>>>>
>>>>> You can add
>>>>>
>>>>> Tested-by: Ludovic Desroches <ludovic.desroches@atmel.com>
>>>>
>>>> Thanks for testing this driver.
>>>>
>>>>>
>>>>> Only one issue but not related to your patches, you can't display
>>>>> quickly the bootup logo since the panel detection takes too much
>>>>> time.
>>>>
>>>> Yes, actually this is related to the device probe order: the
>>>> hlcdc-display-controller device is probed before the simple-panel, thus
>>>> nothing is detected on the RGB connector (I use of_drm_find_panel to
>>>> check for panel availability) when the display controller is
>>>> instantiated. I rely on the default polling infrastructure provided by
>>>> the DRM/KMS framework which polls for a new connector every 10s, and
>>>> this is far more than you kernel boot time.
>>>>
>>>> Do anyone see a solution to reduce this delay (without changing the
>>>> polling interval). I thought we could add a notifier infrastructure to
>>>> the DRM panel framework, but I'm not sure this is how you want things
>>>> done...
>>>
>>> Other drivers return -EPROBE_DEFER when a panel hasn't been registered
>>> yet. This will automatically take care of ordering things in a way that
>>> DRM/KMS will only be initialized after the panel has been probed.
>>
>> Actually I'd like to avoid doing this with a deferred probe, because,
>> AFAIU, the remote endpoint is not tightly linked with the display
>> controller driver (I mean the display controller can still be
>> initialized without having a display connected on it).
>> Moreover the atmel dev kit I'm using has an HDMI bridge connected on
>> the same RGB connector and I'd like to use it in a near future.
>> Returning -EPROBE_DEFER in case of several devices connected on the
>> same connector implies that I'll have to wait for all the remote
>> end-points to be available before my display controller could be
>> instantiated.
>>
>> While this could be acceptable when all drivers are statically linked
>> in the kernel, it might be problematic when you're using modules,
>> meaning that you won't be able to display anything on your LCD panel
>> until your HDMI bridge module has been loaded.
> 
> No. HDMI should be using proper hotplugging anyway, hence it should be
> always be loaded anyway. You're in for a world of pain if you think you
> can run DRM with a driver that's composed of separate kernel modules.
> 
> Also if you don't want to use deferred probe, then you're in for the
> full hotplugging panel dance and that implies that you need to fix a
> bunch of things in DRM (one being the framebuffer console instantiation
> that I referred to in the other thread). You also can't be using the
> current device tree bindings because they all assume a dependency from
> the display controller/output to the panel. For hotplugging you'd need
> the dependency the other way around (the panel needs to refer to the
> output by phandle).

I have tested panel as a module in exynos-dsi + panel-s6e8aa0
configuration, everything works. There is a workaround for fb console
not being reconfigurable, but it does not make thing worse than before.
And I do not see a problem with phandles, ie in DT they point both ways,
according to binding advices at the time, but in the code it is display
controller/encoder which is looking for the panel.

Regards
Andrzej

> 
>>> That
>>> will still cause some delay before everything gets set up, but hopefully
>>> less than what you're seeing now. There's also another thread where this
>>> is being discussed because deferred probing is causing "unacceptable"
>>> delays as well.
>>
>> Could you point this thread out to me please ?
> 
> I Cc'ed you on it.
> 
> Thierry
> 
> 
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
> 

