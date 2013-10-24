Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab3JXJrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:47:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab3JXJri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:47:38 -0400
Date: Thu, 24 Oct 2013 10:49:11 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, jovi.zhangwei@huawei.com,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: ktap inclusion in drivers/staging/?
Message-ID: <20131024094911.GA11921@kroah.com>
References: <20131024075813.GA26929@gmail.com>
 <1382604360.5283.9.camel@pippen.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382604360.5283.9.camel@pippen.local.home>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 04:46:00AM -0400, Steven Rostedt wrote:
> On Thu, 2013-10-24 at 09:58 +0200, Ingo Molnar wrote:
> > Greg,
> > 
> > I was surprised to see 'ktap' appear in the staging tree silently, 
> > via these commits that are visible in today's staging-next:
> > 
> >  2c856b9e3e06 staging: ktap: remove unused <asm/syscall.h> header file
> >  687b63a3bfd5 staging: ktap: update email name in MAINTAINERS
> >  c63a164271f8 staging: ktap: add to the kernel tree
> > 
> > ktap is pretty fresh instrumentation code, announced on lkml a 
> > couple of months ago, and so far I haven't seen much technical 
> > discussion of integrating ktap upstream, mostly I suspect because 
> > not a _single_ patch was sent to linux-kernel for review. (!)
> 
> I feel I'm partially to blame. Jovi has sent us several emails to look
> at his tree and I told him I would when I get time. What I should have
> done was told him to break up the changes and send them out as a patch
> series.
> 
> 
> > 
> > An announcement of a Git tree was made (which Git tree is not very 
> > structured), and some very minimal discussion ensued, but no actual 
> > patches were sent with an intent to merge, no technical arguments 
> > were made in favor of merging and nothing conclusive was achieved.
> 
> Again, this may be partially our fault. We should have told Jovi to send
> out the patches and a pointer to a git tree is not acceptable. Then we
> could have had the necessary discussions required for this.
> 
> But I agree, this should not be just dumped into the staging tree until
> the patches themselves have been posted and reviewed.
> 
> I'll have to NAK it too.

Ok, I've just talked to Ingo in person about this, and I will revert the
ktap code, and work with Jovi to get this merged "properly" for 3.14 or
so.  I do want to audit/change the user/kernel interface in ktap as I'm
not sold on the current one, so after I get that done, I'll work to get
a set of patches created to merge this to the "real" part of the kernel.

Jovi, sorry about this, but the good news is that everyone seems to
agree that this is the way to do this properly, so the end result will
be good for everyone involved.  Again, great job with creating ktap, it
seems that it fills a real need that people are happy to see
implemented.

thanks,

greg k-h
