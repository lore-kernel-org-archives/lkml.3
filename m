Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbbAIN4Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 08:56:16 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:49516 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbbAIN4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 08:56:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Rob Herring <robh@kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Simon Horman <horms@verge.net.au>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Olof Johansson <olof@lixom.net>,
        Simon Horman <horms+renesas@verge.net.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v5][resend v4] of: replace Asahi Kasei Corp vendor prefix
Date: Fri, 09 Jan 2015 14:55:40 +0100
Message-ID: <5363275.ZK3ulH6EUO@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAL_Jsq+GjM+3M63amyh3Rvijkz7Lch_cdUt9vScc9wZeOubOPA@mail.gmail.com>
References: <878ulzx6hr.wl%kuninori.morimoto.gx@gmail.com> <871tn4uv0j.wl%kuninori.morimoto.gx@renesas.com> <CAL_Jsq+GjM+3M63amyh3Rvijkz7Lch_cdUt9vScc9wZeOubOPA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:LtgamboPz8PwhYJPI/DAYdNkjy6+bJnK1NDLIiDWCwrV7V0KjIB
 h4e9lPpI7MSwE2CqTUsicKwtamUle0O1SQeQU5zPAErV7gRmf6IMlNShJJ+NDW/VMeBmE++
 cuBhy6JRcj+3cIUA1qIFhEHO1JR+zg72aoGeLGmVVvviiG3IQUJEeWuSj1wM3GT6OitnfqD
 1opoWSr/0wpcVVPZf/6sQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 January 2015 07:46:16 Rob Herring wrote:
> On Fri, Jan 9, 2015 at 4:07 AM, Kuninori Morimoto
> <kuninori.morimoto.gx@renesas.com> wrote:
> >
> > Hi Stephen
> >
> > Thank you for your feedback
> >
> >> > I'm sending this "of: replace Asahi Kasei Corp vendor prefix" during
> >> > half-year (since Jun 2014) , many times. But, no-one care it.
> >> > I don't know who is the best maintainer.
> >> >  - Stephen : because it has Tegra ?
> >> >  - Olof    : because it has Tegra (= ARM) ?
> >> >  - Arnd    : because it has Tegra (= ARM) ?
> >> >  - Matthias: because it has Tegra (= ARM SoC) ?
> >> >  - Rob     : because DT ?
> >> >  - Andrew  : Last chance ?
> >> >
> >> > But, could you please care this patch ?
> >> > I will re-send it again
> >>
> >> It doesn't seem to be ack'd by any of the DT maintainers. Retro-actively
> >> changing a DT vendor name would need that, I think.
> >
> > Rob ?
> > I had sent this patch to him since half-years ago, many times...
> > Or other maintainer ?
> >
> >> Thierry and Alex (both Tegra maintainers) appear to have ack'd it, so it
> >> seems they expect it to go through some tree other than Tegra. Weren't
> >> there a bunch of related patches along with this (e.g. updating relevant
> >> drivers to support both prefixes?) so it was expected this patch would
> >> be applied together with them?
> >
> > I guess they expected it goes to DT branch (?)
> > This is only 1 patch. it doesn't have related patch-set
> 
> It is in my queue. If the users of it are fine with breaking things,
> who am I to argue with them.

It's an i2c device, so it won't break, based on the implementation
we use in the kernel that ignores the vendor part when the part number
matches the i2c driver name.

I also don't think we need to worry about any non-Linux operating
systems on this board that might share the same dts file.

	Arnd
