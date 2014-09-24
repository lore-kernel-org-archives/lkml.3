Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbaIXOtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:49:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49293 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaIXOtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:49:02 -0400
MIME-Version: 1.0
In-Reply-To: <20140924102012.GB19078@lst.de>
References: <1410786675-7761-1-git-send-email-ming.lei@canonical.com>
	<1410786675-7761-7-git-send-email-ming.lei@canonical.com>
	<20140924102012.GB19078@lst.de>
Date: Wed, 24 Sep 2014 22:49:00 +0800
Message-ID: <CACVXFVMv-mb8LJuJHMJA-3LWYHhV3Cki6fc+_OK3kzXXB2WXnA@mail.gmail.com>
Subject: Re: [PATCH v4 06/10] block: remove blk_init_flush() and its pair
From: Ming Lei <ming.lei@canonical.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 6:20 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Mon, Sep 15, 2014 at 09:11:10PM +0800, Ming Lei wrote:
>> Now mission of the two helpers is over, and just call
>> blk_alloc_flush_queue() and blk_free_flush_queue() directly.
>
> I suspect it might be much easier to fold all previous patches except
> for patch 4, which stands alone into one.  There's just too much churn
> there which doesn't stay in the final version.

Simpler to merge, but more difficult to split. It is for easier review,
since patch 5 is a bit big and each patch still does one thing.

Thanks,
