Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab3JXJtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:49:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37213 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab3JXJtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:49:51 -0400
Date: Thu, 24 Oct 2013 10:49:48 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 05/11] direct-io: only inc/dec inode->i_dio_count for
 file systems
Message-ID: <20131024094948.GT14598@kernel.dk>
References: <1382606764-8309-1-git-send-email-axboe@kernel.dk>
 <1382606764-8309-6-git-send-email-axboe@kernel.dk>
 <20131024094600.GS14598@kernel.dk>
 <20131024094713.GA17840@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131024094713.GA17840@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24 2013, Christoph Hellwig wrote:
> On Thu, Oct 24, 2013 at 10:46:00AM +0100, Jens Axboe wrote:
> > On Thu, Oct 24 2013, Jens Axboe wrote:
> > > We don't need truncate protection for block devices, so add a flag
> > > bypassing this cache line dirtying twice for every IO. This easily
> > > contributes to 5-10% of the CPU time on high IOPS O_DIRECT testing.
> > 
> > There's a merge error in this patch, please find the correct one below.
> 
> Btw, I think this patch should not go in with this series but rather via
> the VFS tree as it's not related to the blk-mq infrastructure at all.

That'd be fine with me, if Al could pick it up if he agrees with it.
Feel free to add an acked/review-by :-)

-- 
Jens Axboe

