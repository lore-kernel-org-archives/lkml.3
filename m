Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbaILLDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 07:03:49 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:58097 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbaILLDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 07:03:44 -0400
MIME-Version: 1.0
In-Reply-To: <1410518771.31130.22.camel@x220>
References: <1406551632.5397.17.camel@x220>
	<1410511111.31130.4.camel@x220>
	<CAGo_u6r3jXX2FS-PO5_-+zhHM3i3pVzGYumSYLh7YPNXGV98eg@mail.gmail.com>
	<1410518771.31130.22.camel@x220>
Date: Fri, 12 Sep 2014 13:03:42 +0200
X-Google-Sender-Auth: 2XYN2tzYUD5YFpzLVco-QYZyNsk
Message-ID: <CAMuHMdUe+GKaYMmbC9JO=Qt7oNiEja0nGbp8oXVS=G4WJHmwJg@mail.gmail.com>
Subject: Re: [PATCH] PM / OPP: Remove ARCH_HAS_OPP completely
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Paul Bolle <pebolle@tiscali.nl>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Nishanth Menon <nm@ti.com>, Mark Brown <broonie@linaro.org>,
        Viresh Kumar <viresh.kumar@linaro.org>, Rob Herring <robh@kernel.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Magnus Damm <magnus.damm@gmail.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul, Rafael,

On Fri, Sep 12, 2014 at 12:46 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
>> >  arch/arm/mach-shmobile/Kconfig | 1 -
>> >  drivers/devfreq/Kconfig        | 1 -
>
> Were patches submitted for these two files too? If so, we can probably
> just drop my patch.

Rafael said: "I've queued this up for 3.17, thanks!"

http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/274681.html

But it's not in -next.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
