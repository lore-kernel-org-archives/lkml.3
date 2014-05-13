Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbaEMHSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 03:18:10 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:50976 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbaEMHSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 03:18:08 -0400
Date: Tue, 13 May 2014 16:18:05 +0900
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Magnus Damm <magnus.damm@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] drivers: sh: compile drivers/sh/pm_runtime.c if
 ARCH_SHMOBILE_MULTI
Message-ID: <20140513071805.GB29453@verge.net.au>
References: <1399411579-10681-1-git-send-email-geert+renesas@glider.be>
 <CAMuHMdWwenyU1RS4c8spFcb7M0oCXP9z8zbGQ0VACKj7EbvvkA@mail.gmail.com>
 <20140511004626.GW31760@verge.net.au>
 <CANqRtoQzxdjwU+BLyccrSzfBx3UMKm6=MAw9dUHSEBWm5_Vspg@mail.gmail.com>
 <20140512070700.GA20505@verge.net.au>
 <CAMuHMdVMCcDK4Y403G26S27oATzLN74iCSM7U+K_ktE-c3uweQ@mail.gmail.com>
 <20140513000455.GA18157@verge.net.au>
 <CAMuHMdVFGOHqq0X6=3gK3wtJGQvHnecP5RKCyye09FbY1CUYgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVFGOHqq0X6=3gK3wtJGQvHnecP5RKCyye09FbY1CUYgQ@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 08:43:49AM +0200, Geert Uytterhoeven wrote:
> Hi Simon,
> 
> On Tue, May 13, 2014 at 2:04 AM, Simon Horman <horms@verge.net.au> wrote:
> > On Mon, May 12, 2014 at 09:25:21AM +0200, Geert Uytterhoeven wrote:
> >> On Mon, May 12, 2014 at 9:07 AM, Simon Horman <horms@verge.net.au> wrote:
> >> > On Mon, May 12, 2014 at 08:24:03AM +0900, Magnus Damm wrote:
> >> >> On Sun, May 11, 2014 at 9:46 AM, Simon Horman <horms@verge.net.au> wrote:
> >> >> > On Thu, May 08, 2014 at 12:12:29PM +0200, Geert Uytterhoeven wrote:
> >> >> >> On Tue, May 6, 2014 at 11:26 PM, Geert Uytterhoeven
> >> >> >> <geert+renesas@glider.be> wrote:
> >> >> >> > Tested on Koelsch (legacy, reference, shmobile, and shmobile+bbb kernels)
> >> >> >> > and BeagleBone Black (shmobile+bbb). Will test on more hardware tomorrow.
> >> >> >>
> >> >> >> Tested on genmai with Wolfram's CCF support.
> >> >> >
> >> >> > Thanks, shall I go ahead and queue this up?
> >> >>
> >> >> Yes please, at least from my side everything looks perfect.
> >> >
> >> > Thanks, will do.
> >> >
> >> > I currently plan to send this on to Linus when the merge window
> >> > opens for v3.16.
> >>
> >> Actually we had hoped this could land in v3.15, so we can fix the regression
> >> introduced in v3.14 by bf98c1eac1d4a6bcf00532e4fa41d8126cd6c187 as
> >> soon as possible.
> >
> > Ok, so I should/can treat this as a fix?
> 
> Yes, definitely.

Thanks, will do.
