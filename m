Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbaIJX6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 19:58:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48253 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaIJX63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 19:58:29 -0400
MIME-Version: 1.0
In-Reply-To: <87y4trhwqr.fsf@rustcorp.com.au>
References: <1409670180-17352-1-git-send-email-ming.lei@canonical.com>
	<20140902162146.GA28741@infradead.org>
	<5405EF38.60007@kernel.dk>
	<20140903121902.7a9f5a5a@tom-ThinkPad-T410>
	<87bnquk4fe.fsf@rustcorp.com.au>
	<878ulyjn23.fsf@rustcorp.com.au>
	<87y4trhwqr.fsf@rustcorp.com.au>
Date: Thu, 11 Sep 2014 07:58:27 +0800
Message-ID: <CACVXFVOX=Tcc9fN_C0FuEHsF22dave9vXtoVct5sx1iK1AWRXg@mail.gmail.com>
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

On Thu, Sep 11, 2014 at 7:38 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Rusty Russell <rusty@rustcorp.com.au> writes:
>> Rusty Russell <rusty@rustcorp.com.au> writes:
>> Here's what I have.  It seems to work as expected, but I haven't
>> benchmarked it.
>
> Hi Ming,
>
>         Any chance you can run your benchmarks against this patch?

I can run the previous benchmark against this patch, but I am wondering
if it is enough since the change need lots of test cases to verify.

BTW, looks your patch doesn't against upstream kernel, since I can't
find alloc_indirect() in drivers/virtio/virtio_ring.c

Thanks,
