Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbaFQKfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 06:35:33 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37134 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaFQKfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 06:35:31 -0400
Date: Tue, 17 Jun 2014 03:35:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ming Lei <tom.leiming@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/3] blk-mq: bitmap tag: Fix few races
Message-ID: <20140617103531.GA13924@infradead.org>
References: <cover.1402582256.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1402582256.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens, did you plan to pick these up?  There's a few bits of low hanging
fruit for cleanups / micro-optimizations in this area, but I don't want
to create conflicts with Alexanders work.

On Thu, Jun 12, 2014 at 05:05:35PM +0200, Alexander Gordeev wrote:
> Hi Jens,
> 
> This series is against for-3.16/blk-mq-tagging branch.
> 
> Cc: Ming Lei <tom.leiming@gmail.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> 
> Alexander Gordeev (3):
>   blk-mq: bitmap tag: fix races on shared ::wake_index fields
>   blk-mq: bitmap tag: fix race on blk_mq_bitmap_tags::wake_cnt
>   blk-mq: bitmap tag: clean-up bt_get() function
> 
>  block/blk-mq-tag.c     |   73 ++++++++++++++++++++++++++---------------------
>  block/blk-mq-tag.h     |    2 +-
>  include/linux/blk-mq.h |    2 +-
>  3 files changed, 42 insertions(+), 35 deletions(-)
> 
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
---end quoted text---
