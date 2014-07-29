Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbaG2XGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 19:06:49 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:46349 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbaG2XGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 19:06:47 -0400
Message-ID: <53D82900.1050409@samsung.com>
Date: Wed, 30 Jul 2014 08:06:40 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "moderated list:ARM/SAMSUNG ARM A..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] ARM: dts: exynos5250: cypress,cyapa trackpad is
 Snow only
References: <1405704009-8430-1-git-send-email-afaerber@suse.de>	<1405704009-8430-3-git-send-email-afaerber@suse.de> <CAD=FV=VAWG=H9=mwKZfip9zvAROU3aVXihnaBUBr0GNSzDoWFw@mail.gmail.com>
In-Reply-To: <CAD=FV=VAWG=H9=mwKZfip9zvAROU3aVXihnaBUBr0GNSzDoWFw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/14 01:16, Doug Anderson wrote:
> Andreas,
>
> On Fri, Jul 18, 2014 at 10:20 AM, Andreas Färber<afaerber@suse.de>  wrote:
>> Move it from exynos5250-cros-common.dtsi to exynos5250-snow.dts.
>> Spring does not need it, it uses an Atmel maXTouch instead.
>>
>> Signed-off-by: Andreas Färber<afaerber@suse.de>
>> ---
>>   v2: New (Doug Anderson)
>>
>>   arch/arm/boot/dts/exynos5250-cros-common.dtsi |  8 --------
>>   arch/arm/boot/dts/exynos5250-snow.dts         | 10 ++++++++++
>>   2 files changed, 10 insertions(+), 8 deletions(-)
>
> Reviewed-by: Doug Anderson<dianders@chromium.org>
>
> Kukjin could apply this now if he wanted to avoid future conflicts.

OK, I read your comments on another this series and I've applied 1/4 and 
2/4 as per your suggestion with your reviewed by tag ;)

And I think, Andreas is going to re-spin remains for exynos5250-spring 
based on updated my -next?

Thanks,
Kukjin
