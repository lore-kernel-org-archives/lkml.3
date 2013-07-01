Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab3GAVlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 17:41:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49808 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab3GAVlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 17:41:08 -0400
Date: Mon, 1 Jul 2013 14:41:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DMA: Fix Marvell Orion and mv_xor after MEMSET removal
Message-Id: <20130701144106.cf0cff602dbff596bf364de0@linux-foundation.org>
In-Reply-To: <20130701213706.GF19937@titan.lakedaemon.net>
References: <1372690589-2218-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<20130701150407.GB19937@titan.lakedaemon.net>
	<20130701124205.9571b26975c1910ce5afa896@linux-foundation.org>
	<20130701213706.GF19937@titan.lakedaemon.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jul 2013 17:37:06 -0400 Jason Cooper <jason@lakedaemon.net> wrote:

> > > Please take a look at the email from lkml I just forwarded to you.  I
> > > believe this solves your problem, but I don't have time to look closely
> > > atm.
> > 
> > Unhelpful.  Can the rest of us see this email as well please?
> 
> Sorry about that, the thread I was referring to on lkml was here:
> 
> http://comments.gmane.org/gmane.linux.kernel/1516018
> 
> And the specific email I was referring to is here (second version of
> Bartlomiej's patch which addresses what Sebastian was attempting to fix):
> 
> http://permalink.gmane.org/gmane.linux.kernel/1517735

Ah, OK, I have that:

http://ozlabs.org/~akpm/mmots/broken-out/drivers-dma-remove-unused-support-for-memset-operations.patch
http://ozlabs.org/~akpm/mmots/broken-out/drivers-dma-remove-unused-support-for-memset-operations-v3.patch
