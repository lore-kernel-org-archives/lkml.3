Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab3GAVhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 17:37:16 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:45618 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754873Ab3GAVhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 17:37:14 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18En67+IuJeHKrQXuKJC7J7aGF2HMjQ8d0=
Date: Mon, 1 Jul 2013 17:37:06 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DMA: Fix Marvell Orion and mv_xor after MEMSET removal
Message-ID: <20130701213706.GF19937@titan.lakedaemon.net>
References: <1372690589-2218-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130701150407.GB19937@titan.lakedaemon.net>
 <20130701124205.9571b26975c1910ce5afa896@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130701124205.9571b26975c1910ce5afa896@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 12:42:05PM -0700, Andrew Morton wrote:
> On Mon, 1 Jul 2013 11:04:07 -0400 Jason Cooper <jason@lakedaemon.net> wrote:
> 
> > On Mon, Jul 01, 2013 at 04:56:29PM +0200, Sebastian Hesselbarth wrote:
> > > Commit 834cbfe966bece50afded79da8e975d255bf0772
> > >  ("drivers/dma: remove unused support for MEMSET operations")
> > > removes MEMSET from dmaengine but does not completely removes it from
> > > Marvell Orion (arch/arm/plat-orion) and XOR (drivers/dma/mv_xor).
> > > This also fixes some compiler warnings about now obsolete functions by
> > > removing those.
> > > 
> > > Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> > > ---
> > > Cc: Jason Cooper <jason@lakedaemon.net>
> > > Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: linux-arm-kernel@lists.infradead.org
> > > Cc: linux-kernel@vger.kernel.org
> > > ---
> > >  arch/arm/plat-orion/common.c |    6 ------
> > >  drivers/dma/mv_xor.c         |   25 +------------------------
> > >  2 files changed, 1 insertions(+), 30 deletions(-)
> > 
> > Please take a look at the email from lkml I just forwarded to you.  I
> > believe this solves your problem, but I don't have time to look closely
> > atm.
> 
> Unhelpful.  Can the rest of us see this email as well please?

Sorry about that, the thread I was referring to on lkml was here:

http://comments.gmane.org/gmane.linux.kernel/1516018

And the specific email I was referring to is here (second version of
Bartlomiej's patch which addresses what Sebastian was attempting to fix):

http://permalink.gmane.org/gmane.linux.kernel/1517735

thx,

Jason.
