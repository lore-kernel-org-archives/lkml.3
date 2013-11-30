Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115Ab3K3N3B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 08:29:01 -0500
Received: from bitmer.com ([213.157.87.50]:48136 "EHLO bitmer.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751982Ab3K3N27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 08:28:59 -0500
Message-ID: <5299E7E2.8040206@bitmer.com>
Date: Sat, 30 Nov 2013 15:28:02 +0200
From: Jarkko Nikula <jarkko.nikula@bitmer.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131005 Icedove/17.0.9
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Sebastian Reichel <sre@debian.org>, Sebastian Reichel <sre@ring0.de>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [RFC 4/4] ASoC: RX-51: Add DT support to sound driver
References: <1382909086-10493-1-git-send-email-sre@debian.org> <1382909086-10493-5-git-send-email-sre@debian.org> <20131106143248.GD15551@amd.pavel.ucw.cz>
In-Reply-To: <20131106143248.GD15551@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 11/06/2013 04:32 PM, Pavel Machek wrote:
> Hi!
> 
>> This patch adds device tree support to the Nokia N900 audio driver.
> 
> Note, N900 audio driver.
> 
>> +- compatible: "nokia,rx51-audio"
> 
> Still, it is rx51-audio. If it is feasible, could we move away from
> rx51 naming and into n900 naming that is familiar to mere humans?
> 
> We can rename the sources later, but I guess we should get dts binding
> right first time...

Sorry the long response. I definitely would like n900 naming more in dts.

History is that the basic board file for N900 went to mainline before
sales started and used the hw name in sources and Kconfig. Audio machine
driver then followed the same rx51 hw naming scheme with rest of sources.

-- 
Jarkko
