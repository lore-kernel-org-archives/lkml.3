Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab3IIShl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:37:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59188 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754661Ab3IIShj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:37:39 -0400
Message-ID: <522E1325.8050906@ti.com>
Date: Mon, 9 Sep 2013 13:27:49 -0500
From: Joel Fernandes <joelf@ti.com>
Reply-To: <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Koen Kooi <koen@dominion.thruhere.net>
CC: Kevin Hilman <khilman@linaro.org>, <bcousson@baylibre.com>,
        <linux-omap@vger.kernel.org>, <tony@atomide.com>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <olof@lixom.net>
Subject: Re: [PATCH] ARM: OMAP2+: am335x-bone*: add DT for BeagleBone Black
References: <1378736961-21005-1-git-send-email-koen@dominion.thruhere.net> <87zjrm81dl.fsf@linaro.org> <BBAC0939-A4F9-4FEA-B137-0307D8787DC3@dominion.thruhere.net>
In-Reply-To: <BBAC0939-A4F9-4FEA-B137-0307D8787DC3@dominion.thruhere.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2013 10:51 AM, Koen Kooi wrote:
> 
> Op 9 sep. 2013, om 17:23 heeft Kevin Hilman <khilman@linaro.org> het volgende geschreven:
> 
>> Koen Kooi <koen@dominion.thruhere.net> writes:
>>
>>> The BeagleBone Black is basically a regular BeagleBone with eMMC and HDMI added,
>>> so create a common dtsi both can use.
>>>
>>> IMPORTANT: booting the existing am335x-bone.dts will blow up the HDMI transceiver
>>> after a dozen boots with an uSD card inserted because LDO will be at 3.3V instead
>>> of 1.8.
>>>
>>> MMC support for AM335x still isn't in, so only the LDO change has been added.
>>>
>>> Cc: stable@vger.kernel.org
>>>
>>> Signed-off-by: Koen Kooi <koen@dominion.thruhere.net>
>>> Tested-by: Tom Rini <trini@ti.com>
>>> Tested-by: Matt Porter <matt.porter@linaro.org>
>>
>> I guess the subject should've included v5?
> 
> Yes, I blame it on being monday :)

The series you're posting will require rebasing on the current MMC DT series
that is being discussed last couple of weeks on the mailing list which were
waiting until now as DMA support was missing. Now that DMA support is pulled in,
it is safe to apply those patches so I will be reposting them shortly.

Please hold off any changes until those patches are posted. This will avoid
unnecessary conflicts.

Thanks,

-Joel
