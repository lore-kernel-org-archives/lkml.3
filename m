Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760788AbaGYPaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:30:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43500 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817AbaGYPaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:30:17 -0400
Message-ID: <53D27804.40601@suse.de>
Date: Fri, 25 Jul 2014 17:30:12 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Kukjin Kim <kgene.kim@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Ben Dooks <ben-linux@fluff.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "ARM/SAMSUNG ARM A..." <linux-arm-kernel@lists.infradead.org>,
        "OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH v2 1/4] ARM: dts: exynos5250: max77686 is Snow only
References: <1405704009-8430-1-git-send-email-afaerber@suse.de>	<1405704009-8430-2-git-send-email-afaerber@suse.de>	<08fe01cfa7c9$341cc700$9c565500$@samsung.com>	<CAD=FV=VUkU7HWjwCKO=WOrKosUtmv3YE_8pxc5uoQg0cHr-AKQ@mail.gmail.com> <CAD=FV=VeBP=1CiKesp738anZzSJNZCGkg68RBUUCyJ5U6_Y75w@mail.gmail.com>
In-Reply-To: <CAD=FV=VeBP=1CiKesp738anZzSJNZCGkg68RBUUCyJ5U6_Y75w@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

Am 25.07.2014 17:13, schrieb Doug Anderson:
> On Fri, Jul 25, 2014 at 8:08 AM, Doug Anderson <dianders@chromium.org> wrote:
>> On Thu, Jul 24, 2014 at 10:28 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
>>> Andreas Färber wrote:
>>>>
>>>> Move it from exynos5250-cros-common.dtsi to exynos5250-snow.dts.
>>>> Spring does not need it, it uses an s5m8767 instead.
>>>>
>>>> Signed-off-by: Andreas Färber <afaerber@suse.de>
>>>> ---
>>>
>>> Doug, can you have a look this series for exynos5250-chromebook?
>>> I'm not sure exynos5250-cros-common is still useful for exynos5250-spring...
>>
>> Right.  The current suggestion is to rework to just duplicate things
>> and don't use exynos5250-cros-common.
> 
> Oh, it actually looks like your patch series ends up there, but the
> first patch confused me.

NP, guess you just started reading in the middle. ;)

>  Why move just the maxim PMIC first?

Review of the movements surely is easier this way, and it did not yet
seem a done deal that we would drop -cros-common. The merge patch nicely
shows which common parts need to be copied into spring.

>  Move
> everything at once and be done with the common file, then do
> cleanup...

If everyone agrees that we want to proceed that way, we can easily
squash patches 1+2. Separating is always harder.

Cheers,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
