Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab3LOUcR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 15:32:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51110 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab3LOUcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 15:32:16 -0500
Date: Sun, 15 Dec 2013 13:32:13 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matias Bjorling <m@bjorling.me>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] null_blk: mem garbage on NUMA systems during init
Message-ID: <20131215203213.GA24924@kernel.dk>
References: <1386690638-8717-1-git-send-email-m@bjorling.me>
 <CA+55aFzFuRoPZmqZ_7GW1SLHvXN90G8pyadJBZfjkKwbNC1ONg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzFuRoPZmqZ_7GW1SLHvXN90G8pyadJBZfjkKwbNC1ONg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 15 2013, Linus Torvalds wrote:
> Jens, ping?
> 
> Patch looks fine, and it looks completely bogus to set
> 
>      null_mq_reg.nr_hw_queues
> 
> to 'nr_online_nodes', when we've potentially done "setup_queues()"
> with just a single queue.
> 
> So I'm going to apply this as-is, I'm just wondering why I haven't
> heard anything from you..

Sorry, I talked with Matias on IM about it, hence no lkml reference to
it. It is queued up. You can apply as-is too, that's fine too.

-- 
Jens Axboe

