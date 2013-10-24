Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225Ab3JXIqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 04:46:11 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:29513 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752517Ab3JXIqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 04:46:09 -0400
Message-ID: <1382604360.5283.9.camel@pippen.local.home>
Subject: Re: ktap inclusion in drivers/staging/?
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jovi.zhangwei@huawei.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Date: Thu, 24 Oct 2013 04:46:00 -0400
In-Reply-To: <20131024075813.GA26929@gmail.com>
References: <20131024075813.GA26929@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-24 at 09:58 +0200, Ingo Molnar wrote:
> Greg,
> 
> I was surprised to see 'ktap' appear in the staging tree silently, 
> via these commits that are visible in today's staging-next:
> 
>  2c856b9e3e06 staging: ktap: remove unused <asm/syscall.h> header file
>  687b63a3bfd5 staging: ktap: update email name in MAINTAINERS
>  c63a164271f8 staging: ktap: add to the kernel tree
> 
> ktap is pretty fresh instrumentation code, announced on lkml a 
> couple of months ago, and so far I haven't seen much technical 
> discussion of integrating ktap upstream, mostly I suspect because 
> not a _single_ patch was sent to linux-kernel for review. (!)

I feel I'm partially to blame. Jovi has sent us several emails to look
at his tree and I told him I would when I get time. What I should have
done was told him to break up the changes and send them out as a patch
series.


> 
> An announcement of a Git tree was made (which Git tree is not very 
> structured), and some very minimal discussion ensued, but no actual 
> patches were sent with an intent to merge, no technical arguments 
> were made in favor of merging and nothing conclusive was achieved.

Again, this may be partially our fault. We should have told Jovi to send
out the patches and a pointer to a git tree is not acceptable. Then we
could have had the necessary discussions required for this.

But I agree, this should not be just dumped into the staging tree until
the patches themselves have been posted and reviewed.

I'll have to NAK it too.

-- Steve


