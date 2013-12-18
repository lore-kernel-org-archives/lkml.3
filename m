Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab3LRQon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 11:44:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59074 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031Ab3LRQol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 11:44:41 -0500
Date: Wed, 18 Dec 2013 17:44:38 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <jaxboe@fusionio.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Use lockless lists for smp_call_function_single()
Message-ID: <20131218164438.GA31692@quack.suse.cz>
References: <1387380302-29552-1-git-send-email-jack@suse.cz>
 <20131218153644.GA16049@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218153644.GA16049@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 18-12-13 07:36:44, Christoph Hellwig wrote:
> On Wed, Dec 18, 2013 at 04:24:59PM +0100, Jan Kara wrote:
> >   Hello,
> > 
> >   these three patches make smp_call_function_single() use lockless lists and
> > cleanup abuse of csd.list in the block layer. I have some use for lockless
> > smp_call_function_single() in printk code and that's why I've picked up
> > Christoph's patch. Jens, can you have a look at the series please?
> 
> seconded.  Also I think your two cleanups should go before my patch.
  Fair enough, I'll reorder the patches in the series and resend.

> I'll also dust up my other patch to use __smp_call_function_single
> directly in the block layer once we make progress on these.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
