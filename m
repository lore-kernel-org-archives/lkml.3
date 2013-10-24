Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135Ab3JXMLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 08:11:38 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:54146 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab3JXMLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 08:11:37 -0400
MIME-Version: 1.0
In-Reply-To: <1382604360.5283.9.camel@pippen.local.home>
References: <20131024075813.GA26929@gmail.com>
	<1382604360.5283.9.camel@pippen.local.home>
Date: Thu, 24 Oct 2013 20:11:36 +0800
Message-ID: <CAGdX0WG1gmC-ZXn5BFRMD5FM2r5d3oxvDU61-xFrT90badv3tg@mail.gmail.com>
Subject: Re: ktap inclusion in drivers/staging/?
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 4:46 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2013-10-24 at 09:58 +0200, Ingo Molnar wrote:
>> Greg,
>>
>> I was surprised to see 'ktap' appear in the staging tree silently,
>> via these commits that are visible in today's staging-next:
>>
>>  2c856b9e3e06 staging: ktap: remove unused <asm/syscall.h> header file
>>  687b63a3bfd5 staging: ktap: update email name in MAINTAINERS
>>  c63a164271f8 staging: ktap: add to the kernel tree
>>
>> ktap is pretty fresh instrumentation code, announced on lkml a
>> couple of months ago, and so far I haven't seen much technical
>> discussion of integrating ktap upstream, mostly I suspect because
>> not a _single_ patch was sent to linux-kernel for review. (!)
>
> I feel I'm partially to blame. Jovi has sent us several emails to look
> at his tree and I told him I would when I get time. What I should have
> done was told him to break up the changes and send them out as a patch
> series.
>
Steven, it's my fault, I'm really sorry for this.

When Greg kindly tried to help merge this into staging tree, I should
talk to you guys firstly, at that time I thought drivers/staging would
be a proper place to cleanup code or integrate with other subsystem,
I'm wrong on this, entirely my fault.

>
>>
>> An announcement of a Git tree was made (which Git tree is not very
>> structured), and some very minimal discussion ensued, but no actual
>> patches were sent with an intent to merge, no technical arguments
>> were made in favor of merging and nothing conclusive was achieved.
>
> Again, this may be partially our fault. We should have told Jovi to send
> out the patches and a pointer to a git tree is not acceptable. Then we
> could have had the necessary discussions required for this.
>
> But I agree, this should not be just dumped into the staging tree until
> the patches themselves have been posted and reviewed.
>
> I'll have to NAK it too.
>
Accept, also with Ingo's.

I admit there have many places need to cleanup in ktap code, and there
also have a long todo list, I will finish it before start review process.

Again, really sorry for this, please forgive me this mistake.

Jovi.
