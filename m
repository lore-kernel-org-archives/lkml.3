Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab3FFPar (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 11:30:47 -0400
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:33226 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab3FFPaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 11:30:46 -0400
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Thu, 6 Jun 2013 11:30:44 -0400
To: Luke Kenneth Casson Leighton <lkcl@lkcl.net>
Cc: Tomasz Figa <tomasz.figa@gmail.com>, linux-arm-kernel@lists.infradead.org,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        debian-kernel@lists.debian.org
Subject: Re: getting allwinner SoC support upstream (was Re: Uploading
 linux (3.9.4-1))
Message-ID: <20130606153044.GZ11182@csclub.uwaterloo.ca>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
 <CAKON4OxDD5orX2w-_+d5kawTGXbE3KKj2QLERo9m7=NiUSXhgQ@mail.gmail.com>
 <CAPweEDzDC87KmOQ=0hyPcjPtPsRuXHxNTs97vbEqVNNnix69rA@mail.gmail.com>
 <19865137.ey1FePPnmD@flatron>
 <CAPweEDzk0T+fZ1aW16D8K4XpvRR2GRrOFtfcjzstnmEJWxmREg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPweEDzk0T+fZ1aW16D8K4XpvRR2GRrOFtfcjzstnmEJWxmREg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 05, 2013 at 11:38:52PM +0100, Luke Kenneth Casson Leighton wrote:
>  their sheer overwhelming success provides us with mass-volume
> ultra-low cost hardware.  to not make an effort to accommodate them
> would in this specific instance be a huge missed opportunity,
> responsibility for which currently falls on the shoulders of the sunxi
> community, where that small community is in no way considered
> "authoritative" as an upstream source and thus every single GNU/Linux
> Distro is left in a position of forcing people to follow insane
> non-standard build procedures that are *way* outside of the capability
> of the average person.

Who cares what their sales volume is.

If they are that successful perhaps they could afford to spend some
resources to fix the mess they have created.

>  so by the linux kernel developers intransigent position, the reach of
> free software as a whole is greatly reduced.  simple logical
> unavoidable conclusion.

Long term having maintainable code is important.  Companies like the
maker of the allwinner come and go.  Maybe in a yaer or two they will be
irrelevant after some much better design from another company takes over
the market.  Perhaps even one sensible enough to work with the community
in the first place, rather than violate the GPL for a long time.

>  please feel free - linux kernel developers - to maintain this
> intransigent position for as long as you find it useful to you to do
> so.  btw, that is a sincere statement, devoid and completely free of
> all and any implicit or explicit additional statements and
> implications.

I have not seen anything mentioned that the allwinner proprietary fex
system does that devicetree does not already do.  So there is no benefit
to anyone (except perhaps allwinner) to adding their system, and a lot
of disadvantages in terms of changes to lots of drivers.  Life would
become much easier for allwinner customers if they did change to
devicetree.  Suddenly a much larger selection of hardware becomes trivial
to include in designs.  Upgrades to new kernels become easier.  Life in
general becomes easier.

>  yeahh, that's rather unfortunate.  i went to some lengths to avoid
> mentioning eoma [*1] until there was a natural point at which it
> became difficult *not* to bring it up, not least because i didn't hear
> anyone else presenting any actual real workable solutions.
> 
> but, you have to bear in mind a couple of things:
> 
> a) i'm a free software developer and advocate.  "business", "lobbying"
> etc. do not come naturally to me.  my associates scream at me
> regularly.
> 
> b) i've been thinking about this incredibly hard problem for at least
> 4 years and almost *all* of my background in computing of the past 30
> years leads me naturally towards actually coming up with a solution
> 
> c) i'm actually really, really really and truly going about *actively*
> implementing that solution rather than just complaining about it *and*
> i'm inviting free software developers to participate, why, because see
> first sentence of a) above.

Well making a tool to convert the fex stuff to devicetree sure sounds
like it could be helpful to allwinner customers.

And if there is anything you know if that can't be represented in
devicetree, I am sure some people would like to know about it.  I doubt
you can come up with anything though.

Clearly adding fex to the upstream kernel isn't a good idea and isn't
going to happen, so any "solution" has to involve getting allwinner to
use devicetree and making doing that as easy as possible.

> [*1] which is an open standard, not a proprietary locked one.

It will be interesting to see if it ever turns into anything, or gets
stuck as just an interesting idea that never took off.

I just checked for my freescale i.mx53, and it has devicetree support
as of 3.3 kernels.  The TI chips I have looked at recently all use
devicetree, even the ones that have not yet been merged upstream.
The marvell armada 370 and xp both appear to have devicetree support.
Nvidia tegras appear to have devicetree support.  not sure if any of
the qualcomm snapdragons have devicetree support yet.

It seems to me almost everyone else is getting on with doing devicetree,
and allwinner is the odd one out that just can't be bothered to get with
the program.

-- 
Len Sorensen
