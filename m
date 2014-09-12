Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbaILLPB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 07:15:01 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:55134 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752835AbaILLO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 07:14:59 -0400
Message-ID: <1410520495.31130.37.camel@x220>
Subject: Re: [PATCH] PM / OPP: Remove ARCH_HAS_OPP completely
From: Paul Bolle <pebolle@tiscali.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Nishanth Menon <nm@ti.com>, Mark Brown <broonie@linaro.org>,
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
Date: Fri, 12 Sep 2014 13:14:55 +0200
In-Reply-To: <CAMuHMdUe+GKaYMmbC9JO=Qt7oNiEja0nGbp8oXVS=G4WJHmwJg@mail.gmail.com>
References: <1406551632.5397.17.camel@x220> <1410511111.31130.4.camel@x220>
	 <CAGo_u6r3jXX2FS-PO5_-+zhHM3i3pVzGYumSYLh7YPNXGV98eg@mail.gmail.com>
	 <1410518771.31130.22.camel@x220>
	 <CAMuHMdUe+GKaYMmbC9JO=Qt7oNiEja0nGbp8oXVS=G4WJHmwJg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Sep 2014 11:14:56.0393 (UTC) FILETIME=[C89A6F90:01CFCE7A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-12 at 13:03 +0200, Geert Uytterhoeven wrote:
> Hi Paul, Rafael,
> 
> On Fri, Sep 12, 2014 at 12:46 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> >> >  arch/arm/mach-shmobile/Kconfig | 1 -
> >> >  drivers/devfreq/Kconfig        | 1 -
> >
> > Were patches submitted for these two files too? If so, we can probably
> > just drop my patch.
> 
> Rafael said: "I've queued this up for 3.17, thanks!"
> 
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/274681.html
> 
> But it's not in -next.

I think that patch landed as commit 78c5e0bb145d. But for some unknown
reason it didn't remove all selects statements for ARCH_HAS_OPP.

The odd thing here is that the last select statements I remove in this
patch are all to be found in Kconfig files that actually were touched in
that commit. Perhaps these select statements were merged back in during
conflict resolution. I have no idea.


Paul Bolle

