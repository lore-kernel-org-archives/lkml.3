Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbaIEG2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 02:28:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41307 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaIEG2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 02:28:50 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVPeGvmv_hSz+_+1Wj3DuUMtQiE-zjq6_fLZveiHH3NuUw@mail.gmail.com>
References: <1409670180-17352-1-git-send-email-ming.lei@canonical.com>
	<20140902162146.GA28741@infradead.org>
	<5405EF38.60007@kernel.dk>
	<20140903121902.7a9f5a5a@tom-ThinkPad-T410>
	<87bnquk4fe.fsf@rustcorp.com.au>
	<CACVXFVPeGvmv_hSz+_+1Wj3DuUMtQiE-zjq6_fLZveiHH3NuUw@mail.gmail.com>
Date: Fri, 5 Sep 2014 14:28:49 +0800
Message-ID: <CACVXFVMGkNAxM0fzLOjBvgvxfVLAxWruMC35CzX_FN5wMk+XQw@mail.gmail.com>
Subject: Re: [PATCH] blk-merge: fix blk_recount_segments
From: Ming Lei <ming.lei@canonical.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kick In <pierre-andre.morey@canonical.com>,
        Chris J Arges <chris.j.arges@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 2:26 PM, Ming Lei <ming.lei@canonical.com> wrote:
> On Fri, Sep 5, 2014 at 1:43 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>
> The main problem is the extra kmalloc(), which might be
> improved by a memory pool.

Or use kind of EWMA model to cache previous allocated indirect descriptors.


Thanks,
