Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab3LRPgs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 10:36:48 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:46129 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923Ab3LRPgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 10:36:47 -0500
Date: Wed, 18 Dec 2013 07:36:44 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <jaxboe@fusionio.com>, Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] Use lockless lists for smp_call_function_single()
Message-ID: <20131218153644.GA16049@infradead.org>
References: <1387380302-29552-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387380302-29552-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 04:24:59PM +0100, Jan Kara wrote:
>   Hello,
> 
>   these three patches make smp_call_function_single() use lockless lists and
> cleanup abuse of csd.list in the block layer. I have some use for lockless
> smp_call_function_single() in printk code and that's why I've picked up
> Christoph's patch. Jens, can you have a look at the series please?

seconded.  Also I think your two cleanups should go before my patch.
I'll also dust up my other patch to use __smp_call_function_single
directly in the block layer once we make progress on these.

