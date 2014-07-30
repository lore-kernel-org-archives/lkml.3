Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbaG3AWC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 20:22:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55238 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbaG3AWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 20:22:00 -0400
Message-ID: <53D83AA1.7080607@suse.de>
Date: Wed, 30 Jul 2014 02:21:53 +0200
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
CC: Doug Anderson <dianders@chromium.org>,
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
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] ARM: dts: exynos5250: cypress,cyapa trackpad is
 Snow only
References: <1405704009-8430-1-git-send-email-afaerber@suse.de>	<1405704009-8430-3-git-send-email-afaerber@suse.de> <CAD=FV=VAWG=H9=mwKZfip9zvAROU3aVXihnaBUBr0GNSzDoWFw@mail.gmail.com> <53D82900.1050409@samsung.com>
In-Reply-To: <53D82900.1050409@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 30.07.2014 01:06, schrieb Kukjin Kim:
> On 07/30/14 01:16, Doug Anderson wrote:
>> On Fri, Jul 18, 2014 at 10:20 AM, Andreas Färber<afaerber@suse.de> 
>> wrote:
>>> Move it from exynos5250-cros-common.dtsi to exynos5250-snow.dts.
>>> Spring does not need it, it uses an Atmel maXTouch instead.
>>>
>>> Signed-off-by: Andreas Färber<afaerber@suse.de>
>>> ---
>>>   v2: New (Doug Anderson)
>>>
>>>   arch/arm/boot/dts/exynos5250-cros-common.dtsi |  8 --------
>>>   arch/arm/boot/dts/exynos5250-snow.dts         | 10 ++++++++++
>>>   2 files changed, 10 insertions(+), 8 deletions(-)
>>
>> Reviewed-by: Doug Anderson<dianders@chromium.org>
>>
>> Kukjin could apply this now if he wanted to avoid future conflicts.
> 
> OK, I read your comments on another this series and I've applied 1/4 and
> 2/4 as per your suggestion with your reviewed by tag ;)

Thanks.

> And I think, Andreas is going to re-spin remains for exynos5250-spring
> based on updated my -next?

Yes. Please don't apply 3/4, I'm fixing a duplicate hdmi node.

Regards,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
