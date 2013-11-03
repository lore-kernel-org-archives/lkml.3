Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab3KCSQw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 13:16:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49648 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753933Ab3KCSQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 13:16:51 -0500
Date: Sun, 3 Nov 2013 11:16:39 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Chen Gang <gang.chen@asianux.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Tejun Heo <tj@kernel.org>,
        Jan Kara <jack@suse.cz>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: trace: blktrace: remove redundent memcpy() in
 compat_blk_trace_setup()
Message-ID: <20131103181639.GA14163@kernel.dk>
References: <52765C6B.7080608@asianux.com>
 <20131103123647.0bae8cf6@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131103123647.0bae8cf6@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 03 2013, Steven Rostedt wrote:
> A quick review of this patch looks fine to me.
> 
> Although, using ARRAY_SIZE() for a character string seems to me a bit
> over paranoid. But I'm fine with it, as it makes sure that the string
> is an array and not a pointer.
> 
> Jens,
> 
> Can you give me an Acked-by?

Thanks, but I'll just queue it up with the other block bits for 3.13.

-- 
Jens Axboe

