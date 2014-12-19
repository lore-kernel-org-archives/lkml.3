Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752494AbaLSWEG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 17:04:06 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63388 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751355AbaLSWEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 17:04:04 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Kevin Hilman <khilman@kernel.org>
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
Date: Fri, 19 Dec 2014 23:25:51 +0100
Message-ID: <1504884.AVoVpOfIGf@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <7h1tnv2tu9.fsf@deeprootsystems.com>
References: <472992175.g1ArEYGFPo@vostro.rjw.lan> <9470157.PyHoGoSGz1@vostro.rjw.lan> <7h1tnv2tu9.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 19, 2014 01:49:34 PM Kevin Hilman wrote:
> "Rafael J. Wysocki" <rjw@rjwysocki.net> writes:
> 
> [...]
> 
> > Fixed up patch is appended, thanks!
> >
> >
> > ---
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Subject: PM: Eliminate CONFIG_PM_RUNTIME
> >
> > Having switched over all of the users of CONFIG_PM_RUNTIME to use
> > CONFIG_PM directly, turn the latter into a user-selectable option
> > and drop the former entirely from the tree.
> >
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
> 
> Acked-by: Kevin Hilman <khilman@linaro.org>
> 
> I assume you're planning to get this in early in the v3.19-rc cycle,
> correct?  That way we can hopefully avoid conflicts with the various
> defconfig changes we're taking through the arm-soc tree.

I'm going to send a pull request with these changes tomorrow.

> Also, thanks for taking care of all the tree-wide changes.  This is a
> great change.

Thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
