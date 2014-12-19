Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684AbaLSVtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 16:49:40 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:39060 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbaLSVth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 16:49:37 -0500
From: Kevin Hilman <khilman@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
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
        "lin ux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH 4/4] PM: Eliminate CONFIG_PM_RUNTIME
References: <472992175.g1ArEYGFPo@vostro.rjw.lan>
	<2635409.SWsBMlb9s4@vostro.rjw.lan>
	<CAMuHMdUn3KSTdh4nFL=G54SM7NWpQsmeg1GYYRz=+uXH9rbEGg@mail.gmail.com>
	<9470157.PyHoGoSGz1@vostro.rjw.lan>
Date: Fri, 19 Dec 2014 13:49:34 -0800
In-Reply-To: <9470157.PyHoGoSGz1@vostro.rjw.lan> (Rafael J. Wysocki's message
	of "Fri, 19 Dec 2014 22:41:54 +0100")
Message-ID: <7h1tnv2tu9.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@rjwysocki.net> writes:

[...]

> Fixed up patch is appended, thanks!
>
>
> ---
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: PM: Eliminate CONFIG_PM_RUNTIME
>
> Having switched over all of the users of CONFIG_PM_RUNTIME to use
> CONFIG_PM directly, turn the latter into a user-selectable option
> and drop the former entirely from the tree.
>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>

Acked-by: Kevin Hilman <khilman@linaro.org>

I assume you're planning to get this in early in the v3.19-rc cycle,
correct?  That way we can hopefully avoid conflicts with the various
defconfig changes we're taking through the arm-soc tree.

Also, thanks for taking care of all the tree-wide changes.  This is a
great change.

Kevin
