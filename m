Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbaHUQLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:11:08 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:11036 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbaHUQLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:11:01 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-2f-53f61a1187fb
Message-id: <53F61A0E.5030104@samsung.com>
Date: Thu, 21 Aug 2014 18:10:54 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
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
 <53F60A82.8090903@samsung.com> <20140821173040.4faa933d@bbrezillon>
In-reply-to: <20140821173040.4faa933d@bbrezillon>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02RXUxSYRjH93IOhyOLdTTRd27pouEWLdKS9lqtvDxdtNncvKgLQ2DoJug4
	YdncwjRUXKm1aVKipsxglBPmMlcTyUJz+REFWiJr9kGu5jIg09USuMi73/Pf/+PiIbGkQTyN
	LFVfUGjU0jIBwcWn/rq9BxLTIgVZ5jYJavD2spAz2IOjrvFpNnoTXiVQ87ceNppesQDU2NrH
	QYHwc4Dsy1428ozcJZDfbwWo//4nDLk6ZMjsm2OhiKeWg1raH+Do4YcgC117Os5BU01s9HvE
	hKPWtiGQx6dtJhuguzeGcNpz4zqL/mifA/Rjo59DW/pDBH2noYNNr8wu4rTd2kjQi94nBG2a
	PEMHmtws2tF3hW5934bTP+3p+TvPco/LFWWllQrNwRPnuSX1txMrhiWXXrZYMB1w7jeABBJS
	OXBifpET5xQ4uzRAGACXTKLMAL42RED8WAOwU6dnR108SgQD9TMxxikhNEV8IMoEtQ/+cSwQ
	UeZThfDzxhgr7k+E67eW8CgnUwi+HboaK8UoKwHrBsZiRbuoAlgTGcTja/cwGLL9iiUSqGyo
	G+3CDIDcSohhYE4UlTEqAzps37EWQBm3bRj/u4zbXN0AswK+QiurYIqVqmwxI1UxWrVSLCtX
	2UH8zaFh0PviqAtQJBDs4Ek3wwVJbGklU6VyAUhigmReILQl8eTSqssKTXmRRlumYFyARSak
	6UCyu1lo1Oo7i6tTfHuVsslDoiOpxvw68CiYKckpXF/dDC8Ea1bRuyn+WgoDz6e+0svNjRN5
	zbmaSST0HAtfHJW1l9bqGzoyq7AMp0o8dq7aLj912P1F/9Wpmr+pdoRqdhdSA3tOWtSS3Pof
	y0pUJKTD/p4Rc/rM6WdZPgHOlEizRZiGkf4Ddr0yW8QCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2014 05:30 PM, Boris BREZILLON wrote:
> On Thu, 21 Aug 2014 17:04:34 +0200
> Andrzej Hajda <a.hajda@samsung.com> wrote:
>
>> On 08/21/2014 03:21 PM, Thierry Reding wrote:
>>> On Thu, Aug 21, 2014 at 12:32:43PM +0200, Andrzej Hajda wrote:
>>>> On 08/21/2014 11:52 AM, Thierry Reding wrote:
>>>>> On Thu, Aug 21, 2014 at 11:41:59AM +0200, Boris BREZILLON wrote:
>>>>>> On Thu, 21 Aug 2014 11:04:07 +0200
>>>>>> Thierry Reding <thierry.reding@gmail.com> wrote:
>>>>>>
>>>>>>> On Thu, Aug 21, 2014 at 10:37:06AM +0200, Boris BREZILLON wrote:
>>>>>>>> Hi Ludovic,
>>>>>>>>
>>>>>>>> On Thu, 21 Aug 2014 10:16:19 +0200
>>>>>>>> Ludovic Desroches <ludovic.desroches@atmel.com> wrote:
>>>>>>>>
>>>>>>>>> Hi Boris,
>>>>>>>>>
>>>>>>>>> You can add
>>>>>>>>>
>>>>>>>>> Tested-by: Ludovic Desroches <ludovic.desroches@atmel.com>
>>>>>>>> Thanks for testing this driver.
>>>>>>>>
>>>>>>>>> Only one issue but not related to your patches, you can't display
>>>>>>>>> quickly the bootup logo since the panel detection takes too much
>>>>>>>>> time.
>>>>>>>> Yes, actually this is related to the device probe order: the
>>>>>>>> hlcdc-display-controller device is probed before the simple-panel, thus
>>>>>>>> nothing is detected on the RGB connector (I use of_drm_find_panel to
>>>>>>>> check for panel availability) when the display controller is
>>>>>>>> instantiated. I rely on the default polling infrastructure provided by
>>>>>>>> the DRM/KMS framework which polls for a new connector every 10s, and
>>>>>>>> this is far more than you kernel boot time.
>>>>>>>>
>>>>>>>> Do anyone see a solution to reduce this delay (without changing the
>>>>>>>> polling interval). I thought we could add a notifier infrastructure to
>>>>>>>> the DRM panel framework, but I'm not sure this is how you want things
>>>>>>>> done...
>>>>>>> Other drivers return -EPROBE_DEFER when a panel hasn't been registered
>>>>>>> yet. This will automatically take care of ordering things in a way that
>>>>>>> DRM/KMS will only be initialized after the panel has been probed.
>>>>>> Actually I'd like to avoid doing this with a deferred probe, because,
>>>>>> AFAIU, the remote endpoint is not tightly linked with the display
>>>>>> controller driver (I mean the display controller can still be
>>>>>> initialized without having a display connected on it).
>>>>>> Moreover the atmel dev kit I'm using has an HDMI bridge connected on
>>>>>> the same RGB connector and I'd like to use it in a near future.
>>>>>> Returning -EPROBE_DEFER in case of several devices connected on the
>>>>>> same connector implies that I'll have to wait for all the remote
>>>>>> end-points to be available before my display controller could be
>>>>>> instantiated.
>>>>>>
>>>>>> While this could be acceptable when all drivers are statically linked
>>>>>> in the kernel, it might be problematic when you're using modules,
>>>>>> meaning that you won't be able to display anything on your LCD panel
>>>>>> until your HDMI bridge module has been loaded.
>>>>> No. HDMI should be using proper hotplugging anyway, hence it should be
>>>>> always be loaded anyway. You're in for a world of pain if you think you
>>>>> can run DRM with a driver that's composed of separate kernel modules.
>>>>>
>>>>> Also if you don't want to use deferred probe, then you're in for the
>>>>> full hotplugging panel dance and that implies that you need to fix a
>>>>> bunch of things in DRM (one being the framebuffer console instantiation
>>>>> that I referred to in the other thread). You also can't be using the
>>>>> current device tree bindings because they all assume a dependency from
>>>>> the display controller/output to the panel. For hotplugging you'd need
>>>>> the dependency the other way around (the panel needs to refer to the
>>>>> output by phandle).
>>>> I have tested panel as a module in exynos-dsi + panel-s6e8aa0
>>>> configuration, everything works. There is a workaround for fb console
>>>> not being reconfigurable, but it does not make thing worse than before.
>>>> And I do not see a problem with phandles, ie in DT they point both ways,
>>>> according to binding advices at the time, but in the code it is display
>>>> controller/encoder which is looking for the panel.
>>> That works because it's DSI. And we have attach/detach callbacks for
>>> DSI. We don't have those for regular panels, so we'd need to find a way
>>> to add that.
>> Maybe I have misread your answer, but you showed it as very
>> difficult/painful
>> process: "hotplugging panel dance", "fix a bunch of things in DRM". In fact
>> we are missing here only good notifications about panel appearance.
>>
>>> The way that this currently works is that an encoder/connector driver
>>> looks up the panel and attaches it to itself. If you allow panels to be
>>> hotpluggable, then they have no knowledge about what they are connected
>>> to, so there needs to be a way to inject that knowledge so that they can
>>> attach to a connector.
>> I do not understand that. Currently it is the connector who looks for
>> the panel
>> and attaches it.
>> So the scenario, after adding panel tracking, could be:
>>  - encoder parses its phandle to panel, and start tracking appearance of
>> the panel
>> identified by this phandle,
>>  - when panel appears encoder callback is called, and encoder attaches
>> the panel,
>>  - when panel wants to disappear encoder callback is called, encoder
>> detaches the panel.
>>
>> All this I have already presented together with generic interface
>> tracker [1].
> Well, your attempt at doing a generic tracker framework sounds
> interesting, but given the answer you've got from greg-kh and Russel,
> I'd say this patch series is in a dead-end (unless there are other
> versions I haven't seen yet).

As I remember I have positively answered Russel's concerns.
Greg had only concern in style 'why another framework'.

>
> How about implementing a specific notifier interface for the drm_panel
> framework first, and move to your generic implementation if it gets
> accepted.

The interface tracker can be also used for that as well, ie it can be
added to
drm_panel framework, until it wont be accepted for wider set of clients.

>
> These are the two proposal I sent to Thierry:
>
> http://code.bulix.org/scq4g3-86804 (v1)
>
> and
>
> http://code.bulix.org/7urh8v-86806 (v2)
>
> Feel free to propose any alternative to those implementations.
>
> Best Regards,
>
> Boris
>
>
After quick look at the patches I guess they will not work correctly
if panel will be added before the observer registration.
Btw in case of other proposals could you include them in the mail,
my company firewall does not like http://code.bulix.org/.

Regards
Andrzej

