Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab3KCUPH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 15:15:07 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:19725 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753950Ab3KCUPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 15:15:05 -0500
Date: Sun, 3 Nov 2013 15:15:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Chen Gang <gang.chen@asianux.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Tejun Heo <tj@kernel.org>,
        Jan Kara <jack@suse.cz>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel: trace: blktrace: remove redundent memcpy() in
 compat_blk_trace_setup()
Message-ID: <20131103151500.2a612ac8@gandalf.local.home>
In-Reply-To: <20131103181639.GA14163@kernel.dk>
References: <52765C6B.7080608@asianux.com>
	<20131103123647.0bae8cf6@gandalf.local.home>
	<20131103181639.GA14163@kernel.dk>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Nov 2013 11:16:39 -0700
Jens Axboe <axboe@kernel.dk> wrote:

> Thanks, but I'll just queue it up with the other block bits for 3.13.
> 

OK,

-- Steve
