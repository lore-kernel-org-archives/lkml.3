Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbbAINqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 08:46:40 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:49922 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbbAINqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 08:46:39 -0500
MIME-Version: 1.0
In-Reply-To: <871tn4uv0j.wl%kuninori.morimoto.gx@renesas.com>
References: <878ulzx6hr.wl%kuninori.morimoto.gx@gmail.com> <20140922130026.GK3290@leverpostej>
 <CAMuHMdX22z97SbGS1HDiYfJ1PXxyEN2S8D7w4sr+4bUwD+mJZw@mail.gmail.com>
 <20140922132743.GM3290@leverpostej> <87y4rfhmgl.wl%kuninori.morimoto.gx@renesas.com>
 <1415845309.4269.6.camel@perches.com> <20141113025105.GA16652@verge.net.au>
 <87vbmjhj00.wl%kuninori.morimoto.gx@renesas.com> <20141113110740.GE3815@sirena.org.uk>
 <87k32yd0bd.wl%kuninori.morimoto.gx@renesas.com> <20141114093554.GC3810@ulmo>
 <87y4ra8xac.wl%kuninori.morimoto.gx@renesas.com> <5469CD47.3040409@cogentembedded.com>
 <877fytxsde.wl%kuninori.morimoto.gx@renesas.com> <87egsob2cl.wl%kuninori.morimoto.gx@renesas.com>
 <5478603D.1080404@cogentembedded.com> <87d282sl6w.wl%kuninori.morimoto.gx@renesas.com>
 <87lhm7t37l.wl%kuninori.morimoto.gx@renesas.com> <87egr4vcxu.wl%kuninori.morimoto.gx@renesas.com>
 <54AF5AB0.2050208@wwwdotorg.org> <871tn4uv0j.wl%kuninori.morimoto.gx@renesas.com>
From: Rob Herring <robh@kernel.org>
Date: Fri, 9 Jan 2015 07:46:16 -0600
X-Google-Sender-Auth: dRsDE2esXwWiXqzhqYcbz2k0_d4
Message-ID: <CAL_Jsq+GjM+3M63amyh3Rvijkz7Lch_cdUt9vScc9wZeOubOPA@mail.gmail.com>
Subject: Re: [PATCH v5][resend v4] of: replace Asahi Kasei Corp vendor prefix
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Brown <broonie@kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2015 at 4:07 AM, Kuninori Morimoto
<kuninori.morimoto.gx@renesas.com> wrote:
>
> Hi Stephen
>
> Thank you for your feedback
>
>> > I'm sending this "of: replace Asahi Kasei Corp vendor prefix" during
>> > half-year (since Jun 2014) , many times. But, no-one care it.
>> > I don't know who is the best maintainer.
>> >  - Stephen : because it has Tegra ?
>> >  - Olof    : because it has Tegra (= ARM) ?
>> >  - Arnd    : because it has Tegra (= ARM) ?
>> >  - Matthias: because it has Tegra (= ARM SoC) ?
>> >  - Rob     : because DT ?
>> >  - Andrew  : Last chance ?
>> >
>> > But, could you please care this patch ?
>> > I will re-send it again
>>
>> It doesn't seem to be ack'd by any of the DT maintainers. Retro-actively
>> changing a DT vendor name would need that, I think.
>
> Rob ?
> I had sent this patch to him since half-years ago, many times...
> Or other maintainer ?
>
>> Thierry and Alex (both Tegra maintainers) appear to have ack'd it, so it
>> seems they expect it to go through some tree other than Tegra. Weren't
>> there a bunch of related patches along with this (e.g. updating relevant
>> drivers to support both prefixes?) so it was expected this patch would
>> be applied together with them?
>
> I guess they expected it goes to DT branch (?)
> This is only 1 patch. it doesn't have related patch-set

It is in my queue. If the users of it are fine with breaking things,
who am I to argue with them.

Rob
