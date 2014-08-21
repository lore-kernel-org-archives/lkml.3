Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbaHUKQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 06:16:12 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:61995 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaHUKQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 06:16:09 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-a3-53f5c6e5b1ec
Message-id: <53F5C6E2.7070604@samsung.com>
Date: Thu, 21 Aug 2014 12:16:02 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.0
MIME-version: 1.0
Newsgroups: gmane.comp.video.dri.devel,gmane.linux.pwm,gmane.linux.drivers.devicetree,gmane.linux.kernel,gmane.linux.ports.arm.kernel
To: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Thierry Reding <thierry.reding@gmail.com>
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
 <20140821114159.319e741b@bbrezillon>
In-reply-to: <20140821114159.319e741b@bbrezillon>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t/xK7pPj30NNvj5Usei49piJosDLxay
	WMw/co7V4srX92wW/W8Wslqce7WS0aJz4hJ2i/tfjzJabHp8jdXi8q45bBZ3765itFi+4imz
	xaGZyRZLr19ksvh2uZndYsL0tSwW6x6+YLJo3XuE3eJ0N6vFz13zWCwmTtvK6CDqsWbeGkaP
	Bb+2snhc7utl8niy6SKjx85Zd9k9Vi7/wuYxu2Mmq8erC3dYPDat6mTzuHNtD5vHvJOBHve7
	jzN5bF5S7zHx9jQWj8+b5AL4o7hsUlJzMstSi/TtErgy9i77w1YwV7pi2rPSBsYGsS5GTg4J
	AROJK7vXMELYYhIX7q1n62Lk4hASWMoo8fjBQ7CEkMAnRonmX8IgNq+AlsSOWbtZQWwWAVWJ
	Wbv2soDYbAKaEn8332QDsUUFwiSe/TrIBFEvKPFj8j0WkKF8Au2MEi1LJ4M1iAikSkz6NgNs
	G7PAX1aJzfvOgHUICwRLNH7byAJxxhdGic75X8DWcQoYSqybuQAowQHUoSdx/6IWSJhZQF5i
	85q3zBMYBWchWTgLoWoWkqoFjMyrGEVTS5MLipPScw31ihNzi0vz0vWS83M3MUKi/MsOxsXH
	rA4xCnAwKvHw3lj0JViINbGsuDL3EKMEB7OSCG/m7q/BQrwpiZVVqUX58UWlOanFhxiZODil
	Ghhnqp23uLBJb1vi58TA1X2fGJ98uNV8wvmkFWvtHQ2uOVXXnjzPz9aztZ697Z+9sdHG059+
	njRpmGdv/Pzv9mUXLkY5RX9Pu7NG0393l+/p/beYZq7u/Gx2MuRY4jbPF5a3dvCcT4h9N2eG
	kpzn1L7wrvepDFLb/gcvfh9x72zaBa2Z6xq1zSZ0KbEUZyQaajEXFScCAD+b+1DQAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2014 11:41 AM, Boris BREZILLON wrote:
> On Thu, 21 Aug 2014 11:04:07 +0200
> Thierry Reding <thierry.reding@gmail.com> wrote:
> 
>> On Thu, Aug 21, 2014 at 10:37:06AM +0200, Boris BREZILLON wrote:
>>> Hi Ludovic,
>>>
>>> On Thu, 21 Aug 2014 10:16:19 +0200
>>> Ludovic Desroches <ludovic.desroches@atmel.com> wrote:
>>>
>>>> Hi Boris,
>>>>
>>>> You can add
>>>>
>>>> Tested-by: Ludovic Desroches <ludovic.desroches@atmel.com>
>>>
>>> Thanks for testing this driver.
>>>
>>>>
>>>> Only one issue but not related to your patches, you can't display
>>>> quickly the bootup logo since the panel detection takes too much
>>>> time.
>>>
>>> Yes, actually this is related to the device probe order: the
>>> hlcdc-display-controller device is probed before the simple-panel, thus
>>> nothing is detected on the RGB connector (I use of_drm_find_panel to
>>> check for panel availability) when the display controller is
>>> instantiated. I rely on the default polling infrastructure provided by
>>> the DRM/KMS framework which polls for a new connector every 10s, and
>>> this is far more than you kernel boot time.
>>>
>>> Do anyone see a solution to reduce this delay (without changing the
>>> polling interval). I thought we could add a notifier infrastructure to
>>> the DRM panel framework, but I'm not sure this is how you want things
>>> done...
>>
>> Other drivers return -EPROBE_DEFER when a panel hasn't been registered
>> yet. This will automatically take care of ordering things in a way that
>> DRM/KMS will only be initialized after the panel has been probed.
> 
> Actually I'd like to avoid doing this with a deferred probe, because,
> AFAIU, the remote endpoint is not tightly linked with the display
> controller driver (I mean the display controller can still be
> initialized without having a display connected on it).
> Moreover the atmel dev kit I'm using has an HDMI bridge connected on
> the same RGB connector and I'd like to use it in a near future.
> Returning -EPROBE_DEFER in case of several devices connected on the
> same connector implies that I'll have to wait for all the remote
> end-points to be available before my display controller could be
> instantiated.
> 
> While this could be acceptable when all drivers are statically linked
> in the kernel, it might be problematic when you're using modules,
> meaning that you won't be able to display anything on your LCD panel
> until your HDMI bridge module has been loaded.

I agree that deferring whole drm initialization due to panel not being
ready is not an optimal solution. Nice solution of this problem is with
DSI panels, DSI bus infrastructure provides callbacks for DRM encoder
which are called when DSI panel is ready. Simple panels are platform
devices so they do not have such callbacks. To solve this in a generic
way I have proposed framework for tracking interfaces[1], the series
contains also solution for the same problem with exynos display
controller[2].

Regards
Andrzej

[1]: https://lkml.org/lkml/2014/4/30/345
[2]: https://lkml.org/lkml/2014/4/30/653

> 
>> That
>> will still cause some delay before everything gets set up, but hopefully
>> less than what you're seeing now. There's also another thread where this
>> is being discussed because deferred probing is causing "unacceptable"
>> delays as well.
> 
> Could you point this thread out to me please ?
> 
> Best Regards,
> 
> Boris
> 

