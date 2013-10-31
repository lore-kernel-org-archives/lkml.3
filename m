Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab3JaOo0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 10:44:26 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:37599 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599Ab3JaOoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 10:44:24 -0400
MIME-Version: 1.0
In-Reply-To: <1382909086-10493-5-git-send-email-sre@debian.org>
References: <1382909086-10493-1-git-send-email-sre@debian.org>
	<1382909086-10493-5-git-send-email-sre@debian.org>
Date: Thu, 31 Oct 2013 07:44:22 -0700
Message-ID: <CACRpkdb1dAiDCeZkOiZ6inbDruaUwLgk3joWwuQmSRNZ9WkDGw@mail.gmail.com>
Subject: Re: [RFC 4/4] ASoC: RX-51: Add DT support to sound driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 2:24 PM, Sebastian Reichel <sre@debian.org> wrote:

> +- eci-sw-gpio: GPIO for ECI SW
> +- speaker-amp-gpio: GPIO for Speaker Amp

Can you please spell out the acronyms? ECI? SW? Amp?

I guess SW=switch, Amp=amplifier, but ECI beats me.

Yours,
Linus Walleij
