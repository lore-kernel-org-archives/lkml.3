Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbaIZEfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 00:35:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59706 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbaIZEfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 00:35:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140925163015.GA31234@lst.de>
References: <1411658627-19754-1-git-send-email-ming.lei@canonical.com>
	<20140925163015.GA31234@lst.de>
Date: Fri, 26 Sep 2014 12:35:14 +0800
Message-ID: <CACVXFVN-tq=ysRZzGnpXsZTtO82DykN4Dqn7djjz6ze4L+TNww@mail.gmail.com>
Subject: Re: [PATCH v5 0/10] block: per-distpatch_queue flush machinery
From: Ming Lei <ming.lei@canonical.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 12:30 AM, Christoph Hellwig <hch@lst.de> wrote:
> To review this properly I had to actually squatch patches 2-4 and 6-9
> into a single patch to read nicely over it, the result is attached below.
>
> That one has one minor issue in __blk_drain_queue where a newly added
> indent uses 4 spaces instead of tabs, but otherwise everything in this
> series looks fine to me and passes sanity testing with scsi-mq.
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Great thanks for your review.

Thanks,
