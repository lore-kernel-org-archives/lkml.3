Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaLSINd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 03:13:33 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:60394 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbaLSINb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 03:13:31 -0500
MIME-Version: 1.0
In-Reply-To: <2635409.SWsBMlb9s4@vostro.rjw.lan>
References: <472992175.g1ArEYGFPo@vostro.rjw.lan>
	<2635409.SWsBMlb9s4@vostro.rjw.lan>
Date: Fri, 19 Dec 2014 09:13:29 +0100
X-Google-Sender-Auth: NegosbHWJgJKZ1PRDwtFvunBHwI
Message-ID: <CAMuHMdUn3KSTdh4nFL=G54SM7NWpQsmeg1GYYRz=+uXH9rbEGg@mail.gmail.com>
Subject: Re: [PATCH 4/4] PM: Eliminate CONFIG_PM_RUNTIME
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Kukjin Kim <kgene@kernel.org>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Mark Brown <broonie@kernel.org>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 3:03 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> --- linux-pm.orig/arch/mips/configs/lemote2f_defconfig
> +++ linux-pm/arch/mips/configs/lemote2f_defconfig
> @@ -37,7 +37,7 @@ CONFIG_MIPS32_N32=y
>  CONFIG_PM=y
  ^^^^^^^^^^^
>  CONFIG_HIBERNATION=y
>  CONFIG_PM_STD_PARTITION="/dev/hda3"
> -CONFIG_PM_RUNTIME=y
> +CONFIG_PM=y
   ^^^^^^^^^^^
Now we have two of them

>  CONFIG_CPU_FREQ=y
>  CONFIG_CPU_FREQ_DEBUG=y
>  CONFIG_CPU_FREQ_STAT=m

Other defconfig files may be affected, too.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
