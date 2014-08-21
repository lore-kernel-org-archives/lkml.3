Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbaHUPEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 11:04:47 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:45414 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaHUPEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 11:04:45 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-e8-53f60a8a3320
Message-id: <53F60A82.8090903@samsung.com>
Date: Thu, 21 Aug 2014 17:04:34 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Mark Rutland <mark.rutland@arm.com>, linux-pwm@vger.kernel.org,
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
 <53F5CACB.5010706@samsung.com> <20140821132124.GB19293@ulmo.nvidia.com>
In-reply-to: <20140821132124.GB19293@ulmo.nvidia.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t/xq7pdXN+CDTacYbfouLaYyeLAi4Us
	FvOPnGO1uPL1PZtF/5uFrBbnXq1ktOicuITd4v7Xo4wWmx5fY7W4vGsOm8Xdu6sYLZaveMps
	cWhmssXS6xeZLL5dbma3mDB9LYvFuocvmCxa9x5htzjdzWrxc9c8FouJ07YyOoh6rJm3htFj
	wa+tLB6X+3qZPJ5susjosXPWXXaPlcu/sHnM7pjJ6vHqwh0Wj02rOtk87lzbw+Yx72Sgx/3u
	40wem5fUe0y8PY3F4/MmuQD+KC6blNSczLLUIn27BK6Mtm0XWQo+aFYcmeDdwNig1MXIySEh
	YCIx40I3O4QtJnHh3no2EFtIYCmjROtC6S5GLiD7E6NEx70PjCAJXgEtiZ7bi1lAbBYBVYml
	jy+ANbMJaEr83XwTrFlUIEzi2a+DTBD1ghI/Jt8DqxcR0JX4f/oNC8hQZoGtbBKzHx9gBUkI
	CwRLNH7byAKx7Q6TxO63F5hBEpwCphI3b50FKuIA6tCTuH9RCyTMLCAvsXnNW+YJjAKzkOyY
	hVA1C0nVAkbmVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghsfx1B+PSY1aHGAU4GJV4eCO/
	fA0WYk0sK67MPcQowcGsJMJ7HyTEm5JYWZValB9fVJqTWnyIkYmDU6qBMbPwaae1R1m3UGFA
	7ZlvixdtZ4v4VGr/p720clHa8ljzYx0T/rR+az/RkeB6KqnzcnrYhKSDgvv2p5xtXzJBSGJ/
	zsVMv7yIWVsWcOs2X2L5vGW/CMccofJT13cruZ6ymGnSWnsnOqCJY1b3/CfrM1bte2q42XtK
	36vcEONoJjalXwrHfH/7K7EUZyQaajEXFScCACQQsVPDAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2014 03:21 PM, Thierry Reding wrote:
> On Thu, Aug 21, 2014 at 12:32:43PM +0200, Andrzej Hajda wrote:
>> On 08/21/2014 11:52 AM, Thierry Reding wrote:
>>> On Thu, Aug 21, 2014 at 11:41:59AM +0200, Boris BREZILLON wrote:
>>>> On Thu, 21 Aug 2014 11:04:07 +0200
>>>> Thierry Reding <thierry.reding@gmail.com> wrote:
>>>>
>>>>> On Thu, Aug 21, 2014 at 10:37:06AM +0200, Boris BREZILLON wrote:
>>>>>> Hi Ludovic,
>>>>>>
>>>>>> On Thu, 21 Aug 2014 10:16:19 +0200
>>>>>> Ludovic Desroches <ludovic.desroches@atmel.com> wrote:
>>>>>>
>>>>>>> Hi Boris,
>>>>>>>
>>>>>>> You can add
>>>>>>>
>>>>>>> Tested-by: Ludovic Desroches <ludovic.desroches@atmel.com>
>>>>>> Thanks for testing this driver.
>>>>>>
>>>>>>> Only one issue but not related to your patches, you can't display
>>>>>>> quickly the bootup logo since the panel detection takes too much
>>>>>>> time.
>>>>>> Yes, actually this is related to the device probe order: the
>>>>>> hlcdc-display-controller device is probed before the simple-panel, thus
>>>>>> nothing is detected on the RGB connector (I use of_drm_find_panel to
>>>>>> check for panel availability) when the display controller is
>>>>>> instantiated. I rely on the default polling infrastructure provided by
>>>>>> the DRM/KMS framework which polls for a new connector every 10s, and
>>>>>> this is far more than you kernel boot time.
>>>>>>
>>>>>> Do anyone see a solution to reduce this delay (without changing the
>>>>>> polling interval). I thought we could add a notifier infrastructure to
>>>>>> the DRM panel framework, but I'm not sure this is how you want things
>>>>>> done...
>>>>> Other drivers return -EPROBE_DEFER when a panel hasn't been registered
>>>>> yet. This will automatically take care of ordering things in a way that
>>>>> DRM/KMS will only be initialized after the panel has been probed.
>>>> Actually I'd like to avoid doing this with a deferred probe, because,
>>>> AFAIU, the remote endpoint is not tightly linked with the display
>>>> controller driver (I mean the display controller can still be
>>>> initialized without having a display connected on it).
>>>> Moreover the atmel dev kit I'm using has an HDMI bridge connected on
>>>> the same RGB connector and I'd like to use it in a near future.
>>>> Returning -EPROBE_DEFER in case of several devices connected on the
>>>> same connector implies that I'll have to wait for all the remote
>>>> end-points to be available before my display controller could be
>>>> instantiated.
>>>>
>>>> While this could be acceptable when all drivers are statically linked
>>>> in the kernel, it might be problematic when you're using modules,
>>>> meaning that you won't be able to display anything on your LCD panel
>>>> until your HDMI bridge module has been loaded.
>>> No. HDMI should be using proper hotplugging anyway, hence it should be
>>> always be loaded anyway. You're in for a world of pain if you think you
>>> can run DRM with a driver that's composed of separate kernel modules.
>>>
>>> Also if you don't want to use deferred probe, then you're in for the
>>> full hotplugging panel dance and that implies that you need to fix a
>>> bunch of things in DRM (one being the framebuffer console instantiation
>>> that I referred to in the other thread). You also can't be using the
>>> current device tree bindings because they all assume a dependency from
>>> the display controller/output to the panel. For hotplugging you'd need
>>> the dependency the other way around (the panel needs to refer to the
>>> output by phandle).
>> I have tested panel as a module in exynos-dsi + panel-s6e8aa0
>> configuration, everything works. There is a workaround for fb console
>> not being reconfigurable, but it does not make thing worse than before.
>> And I do not see a problem with phandles, ie in DT they point both ways,
>> according to binding advices at the time, but in the code it is display
>> controller/encoder which is looking for the panel.
> That works because it's DSI. And we have attach/detach callbacks for
> DSI. We don't have those for regular panels, so we'd need to find a way
> to add that.

Maybe I have misread your answer, but you showed it as very
difficult/painful
process: "hotplugging panel dance", "fix a bunch of things in DRM". In fact
we are missing here only good notifications about panel appearance.

>
> The way that this currently works is that an encoder/connector driver
> looks up the panel and attaches it to itself. If you allow panels to be
> hotpluggable, then they have no knowledge about what they are connected
> to, so there needs to be a way to inject that knowledge so that they can
> attach to a connector.

I do not understand that. Currently it is the connector who looks for
the panel
and attaches it.
So the scenario, after adding panel tracking, could be:
 - encoder parses its phandle to panel, and start tracking appearance of
the panel
identified by this phandle,
 - when panel appears encoder callback is called, and encoder attaches
the panel,
 - when panel wants to disappear encoder callback is called, encoder
detaches the panel.

All this I have already presented together with generic interface
tracker [1].

Regards
Andrzej

[1]: https://lkml.org/lkml/2014/4/30/345


>
> Thierry

