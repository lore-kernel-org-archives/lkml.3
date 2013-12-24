Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758251Ab3LXDfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 22:35:31 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:50118 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab3LXDfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 22:35:30 -0500
MIME-Version: 1.0
In-Reply-To: <20131223162531.GB9383@infradead.org>
References: <1387815539-12257-1-git-send-email-tom.leiming@gmail.com>
	<1387815539-12257-3-git-send-email-tom.leiming@gmail.com>
	<20131223162531.GB9383@infradead.org>
Date: Tue, 24 Dec 2013 11:35:29 +0800
Message-ID: <CACVXFVOnWLUQPiPsHOyhhU66+M8B6v0cpCDgLp55S+anORzxAA@mail.gmail.com>
Subject: Re: [PATCH 2/4] block: blk-mq: make blk_sync_queue support mq
From: Ming Lei <tom.leiming@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Christoph,


On Tue, Dec 24, 2013 at 12:25 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Dec 24, 2013 at 12:18:57AM +0800, Ming Lei wrote:
>> This patch moves synchronization on mq->delay_work
>> from blk_mq_free_queue() to blk_sync_queue(), so that
>> blk_sync_queue can work on mq.
>
> Again, this is a LLD call, should have a separate blk_mq_sync_queue.
>

As I replied in previous mail, we have other LLD APIs which should be
called for MQ too, also making current APIs adapt to MQ can simplify
drivers.


Thanks,
-- 
Ming Lei
