Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab3LRUuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 15:50:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35193 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751242Ab3LRUuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 15:50:20 -0500
Date: Wed, 18 Dec 2013 21:50:15 +0100
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/3 v2] Use lockless lists for smp_call_function_single()
Message-ID: <20131218205015.GA13685@quack.suse.cz>
References: <1387387418-10005-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387387418-10005-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 18-12-13 18:23:32, Jan Kara wrote:
>   Hello,
> 
>   these three patches make smp_call_function_single() use lockless lists and
> cleanup abuse of csd.list in the block layer. I have some use for lockless
> smp_call_function_single() in printk code and that's why I've picked up
> Christoph's patch. Jens, can you have a look at the series please?
> 
> Changes since v1:
> * Reordered patches to a more sensible order.
  Bah, I screwed up. I had both new and older version of the patches in the
directory for sending. Since it is just three patches, I'll just mark
correct patches by email but if that is a problem I can resend as well.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
