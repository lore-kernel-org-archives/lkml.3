Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab3J0W3d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 18:29:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38468 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab3J0W3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 18:29:32 -0400
Date: Sun, 27 Oct 2013 22:29:25 +0000
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Gordeev <agordeev@redhat.com>, Tejun Heo <tj@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>, linux-kernel@vger.kernel.org
Subject: Re: blk-mq flush fix
Message-ID: <20131027222914.GG22549@kernel.dk>
References: <20131026114612.GA8576@infradead.org>
 <20131026153124.GA22227@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131026153124.GA22227@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26 2013, Christoph Hellwig wrote:
> I think this variant of the patch from Alexander should fix the issue
> in a minimally invasive way.  Longer term I'd prefer to use q->flush_rq
> like in the non-mq case by copying over the context and tag information.

This one is pretty simple, we could definitely use it as a band aid. I
too would greatly prefer using the static ->flush_rq instead. Just have
it marked to bypass most of the free logic.

I'll add this one.

-- 
Jens Axboe

