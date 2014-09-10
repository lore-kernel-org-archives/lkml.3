Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaIJXqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 19:46:12 -0400
Received: from ozlabs.org ([103.22.144.67]:49899 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbaIJXqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 19:46:10 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ming Lei <ming.lei@canonical.com>, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        Kick In <pierre-andre.morey@canonical.com>,
        Chris J Arges <chris.j.arges@canonical.com>
Subject: Re: [PATCH] blk-merge: fix blk_recount_segments
In-Reply-To: <878ulyjn23.fsf@rustcorp.com.au>
References: <1409670180-17352-1-git-send-email-ming.lei@canonical.com> <20140902162146.GA28741@infradead.org> <5405EF38.60007@kernel.dk> <20140903121902.7a9f5a5a@tom-ThinkPad-T410> <87bnquk4fe.fsf@rustcorp.com.au> <878ulyjn23.fsf@rustcorp.com.au>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 11 Sep 2014 09:08:36 +0930
Message-ID: <87y4trhwqr.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell <rusty@rustcorp.com.au> writes:
> Rusty Russell <rusty@rustcorp.com.au> writes:
> Here's what I have.  It seems to work as expected, but I haven't
> benchmarked it.

Hi Ming,

        Any chance you can run your benchmarks against this patch?

Thanks,
Rusty.
