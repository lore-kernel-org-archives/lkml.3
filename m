Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759041Ab3GaHd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 03:33:26 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:34552 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab3GaHdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 03:33:24 -0400
Date: Wed, 31 Jul 2013 16:33:21 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Tetsuyuki Kobayashi <koba@kmckk.co.jp>,
        SH-Linux <linux-sh@vger.kernel.org>
Subject: Re: [PATCH] ARM: shmobile: emev2: add PMU information to emev2.dtsi
Message-ID: <20130731073320.GH5090@verge.net.au>
References: <20130724034240.30596.52917.sendpatchset@w520>
 <20130731063900.GA5090@verge.net.au>
 <20130731070550.GA28921@verge.net.au>
 <CANqRtoTVVp5xY7monC6c87Ni=pS5dNG=fS_isAg3qZNQCzaNNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANqRtoTVVp5xY7monC6c87Ni=pS5dNG=fS_isAg3qZNQCzaNNg@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 04:11:23PM +0900, Magnus Damm wrote:
> Hi Simon,
> 
> On Wed, Jul 31, 2013 at 4:05 PM, Simon Horman <horms@verge.net.au> wrote:
> > On Wed, Jul 31, 2013 at 03:39:04PM +0900, Simon Horman wrote:
> >> On Wed, Jul 24, 2013 at 12:42:40PM +0900, Magnus Damm wrote:
> >> > From: Magnus Damm <damm@opensource.se>
> >> >
> >> > Add PMU information to emev2.dtsi. With this
> >> > included KZM9D DT reference may use the PMU.
> >>
> >> Thanks, I will queue this up for v3.12 in the dt2 branch.
> >
> > When booting a debian armel userspace with this patch applied on top of
> > renesas-devel-20130731 I see the following.
> >
> > I do not observe this problem with the sh73a0 or r8a7740 versions
> > of this patch applied, though I assume that in the case of the r8a7740
> > that is because it is UP.
> 
> Looks like the STI clockevent rating patch is missing. SMP operation
> of EMEV2 is broken without that patch.

Thanks, that patch resolves the problem that I was seeing.

I'll put it into devel for now in topic/em_sti.
topic/ indicating that is isn't queued-up yet as
I'd like to give the clocksource people a chance to review it.
