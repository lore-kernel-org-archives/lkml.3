Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbaFMWWO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 18:22:14 -0400
Received: from smtprelay0074.hostedemail.com ([216.40.44.74]:57931 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753839AbaFMWWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 18:22:12 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:421:541:599:960:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:2110:2393:2525:2553:2560:2563:2682:2685:2828:2859:2911:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4425:4605:5007:7522:7652:7875:7903:8660:8957
X-HE-Tag: robin28_12c9e3547c15d
X-Filterd-Recvd-Size: 3394
Message-ID: <1402698126.2727.13.camel@joe-AO725>
Subject: Re: [PATCH V2 00/19] irqchip: crossbar: driver fixes
From: Joe Perches <joe@perches.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>, Sricharan R <r.sricharan@ti.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        tony@atomide.com, santosh.shilimkar@ti.com, nm@ti.com, rnayak@ti.com,
        linux@arm.linux.org.uk
Date: Fri, 13 Jun 2014 15:22:06 -0700
In-Reply-To: <alpine.DEB.2.10.1406132222570.5170@nanos>
References: <1402574007-13987-1-git-send-email-r.sricharan@ti.com>
	 <20140613150122.GP8664@titan.lakedaemon.net>
	 <1402676074.12385.40.camel@joe-AO725>
	 <20140613163714.GR8664@titan.lakedaemon.net>
	 <1402678104.3509.1.camel@joe-AO725>
	 <20140613165458.GS8664@titan.lakedaemon.net>
	 <alpine.DEB.2.10.1406132222570.5170@nanos>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-13 at 22:38 +0200, Thomas Gleixner wrote:
> On Fri, 13 Jun 2014, Jason Cooper wrote:
> > On Fri, Jun 13, 2014 at 09:48:24AM -0700, Joe Perches wrote:
> > > On Fri, 2014-06-13 at 12:37 -0400, Jason Cooper wrote:
> > > > On Fri, Jun 13, 2014 at 09:14:34AM -0700, Joe Perches wrote:
> > > > > On Fri, 2014-06-13 at 11:01 -0400, Jason Cooper wrote:
> > > > > > Please format the subject lines like so:
> > > > > > 
> > > > > >   irqchip: crossbar: Set cb pointer ...
> > > > > >                      ^
> > > > > >                      |
> > > > > >                      \-- note the capitalization
> > > > > 
> > > > > I suggest you don't make this a rule and focus
> > > > > on more important stuff instead.

[elided the bit that describes what a patch subject looks like]

Documentation/SubmittingPatches simply says:

The canonical patch subject line is:

    Subject: [PATCH 001/123] subsystem: summary phrase

It doesn't say anything about capitalization.

> Sentences start with an upper case letter. Our brain is trained on
> that rule when parsing a line.

<shrug>  I don't think patch subjects are sentences.
The docs call them phrases.

> So for people who actually review patches by reading them instead of
> running a spell checker, consistent formatting more important than
> avoiding the random typo, which our brain just blends out in most of
> the cases. Unfortunately also when the typo is in actual code :(

That part about the code is truth.

Anyway, how you spend your time is certainly up to you.
Do what makes you happy.

But if you want this specific form for your patches,
please just document it somewhere in the kernel tree.

I think that relatively commit log subjects are generally
easy to parse as-is and don't need more strictures.

I think it akin to british/american spelling uses and
I and i.  I just don't care which people use.

I did propose a mechanism to nudge people when proposed
patch subjects don't fit some specific maintainer's idea
of proper.

https://lkml.org/lkml/2010/11/16/245

cheers, Joe




