Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735Ab3LWQZg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:25:36 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:36769 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757412Ab3LWQZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:25:32 -0500
Date: Mon, 23 Dec 2013 08:25:31 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] block: blk-mq: make blk_sync_queue support mq
Message-ID: <20131223162531.GB9383@infradead.org>
References: <1387815539-12257-1-git-send-email-tom.leiming@gmail.com>
 <1387815539-12257-3-git-send-email-tom.leiming@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387815539-12257-3-git-send-email-tom.leiming@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 12:18:57AM +0800, Ming Lei wrote:
> This patch moves synchronization on mq->delay_work
> from blk_mq_free_queue() to blk_sync_queue(), so that
> blk_sync_queue can work on mq.

Again, this is a LLD call, should have a separate blk_mq_sync_queue.

