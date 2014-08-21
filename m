Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaHUPl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 11:41:26 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:40186 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbaHUPlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 11:41:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140821153836.GO4266@lee--X1>
References: <1408627817-16171-1-git-send-email-zyw@rock-chips.com>
	<20140821153836.GO4266@lee--X1>
Date: Thu, 21 Aug 2014 08:41:23 -0700
X-Google-Sender-Auth: DoXxe2zuPfleLun8KCF2NP6wc2E
Message-ID: <CAD=FV=VYy5sgLmjUfUGe0ai=wMBFHROLK6yKvMzfmundWSMiCA@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] MFD: RK808: Add new mfd driver for RK808
From: Doug Anderson <dianders@chromium.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Chris Zhong <zyw@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Grant Likely <grant.likely@linaro.org>,
        Lin Huang <hl@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, zhangqing <zhangqing@rock-chips.com>,
        xxx <xxx@rock-chips.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Dmitry Torokhov <dtor@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kever Yang <kever.yang@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee,

On Thu, Aug 21, 2014 at 8:38 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Thu, 21 Aug 2014, Chris Zhong wrote:
>> The RK808 chip is a power management IC for multimedia and handheld
>> devices. It contains the following components:
>>
>> - Regulators
>> - RTC
>>
>> The rk808 core driver is registered as a platform driver and provides
>> communication through I2C with the host device for the different
>> components.
>>
>> Signed-off-by: Chris Zhong <zyw@rock-chips.com>
>>
>> ---
>>
>> Changes in v3: None
>
> Why haven't you fixed up my review comments?

I saw in a private message from Chris that his v2 was actually the
wrong version (an old branch from his tree) by mistake.  His v3 is
what v2 was supposed to be.  He didn't have time to fixup review
comments yet (he just wanted to send the correct v2), so expect a v4.

Chris: you probably should have included that somewhere in your email
on the lists so people weren't confused.

-Doug
