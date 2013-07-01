Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab3GATmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 15:42:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754061Ab3GATmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 15:42:07 -0400
Date: Mon, 1 Jul 2013 12:42:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DMA: Fix Marvell Orion and mv_xor after MEMSET removal
Message-Id: <20130701124205.9571b26975c1910ce5afa896@linux-foundation.org>
In-Reply-To: <20130701150407.GB19937@titan.lakedaemon.net>
References: <1372690589-2218-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<20130701150407.GB19937@titan.lakedaemon.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jul 2013 11:04:07 -0400 Jason Cooper <jason@lakedaemon.net> wrote:

> On Mon, Jul 01, 2013 at 04:56:29PM +0200, Sebastian Hesselbarth wrote:
> > Commit 834cbfe966bece50afded79da8e975d255bf0772
> >  ("drivers/dma: remove unused support for MEMSET operations")
> > removes MEMSET from dmaengine but does not completely removes it from
> > Marvell Orion (arch/arm/plat-orion) and XOR (drivers/dma/mv_xor).
> > This also fixes some compiler warnings about now obsolete functions by
> > removing those.
> > 
> > Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> > ---
> > Cc: Jason Cooper <jason@lakedaemon.net>
> > Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  arch/arm/plat-orion/common.c |    6 ------
> >  drivers/dma/mv_xor.c         |   25 +------------------------
> >  2 files changed, 1 insertions(+), 30 deletions(-)
> 
> Please take a look at the email from lkml I just forwarded to you.  I
> believe this solves your problem, but I don't have time to look closely
> atm.

Unhelpful.  Can the rest of us see this email as well please?
