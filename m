Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbaEOPkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:40:12 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:64918 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752530AbaEOPkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:40:10 -0400
Date: Thu, 15 May 2014 11:40:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: chrubis@suse.cz
Cc: Darren Hart <dvhart@linux.intel.com>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>,
        "Carlos O'Donell" <carlos@redhat.com>
Subject: Re: futex(2) man page update help request
Message-ID: <20140515114006.52a4e07d@gandalf.local.home>
In-Reply-To: <20140515152834.GA6926@rei.Home>
References: <537346E5.4050407@gmail.com>
	<CF98E3EF.90564%dvhart@linux.intel.com>
	<20140515152834.GA6926@rei.Home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2014 17:28:35 +0200
chrubis@suse.cz wrote:

> Hi!
> > 
> > However, unless I'm sorely mistaken, the larger problem is that glibc
> > removed the futex() call entirely, so these man pages don't describe
> > something users even have access to anymore. I had to revert to calling
> > the syscalls directly in the futextest test suite because of this:
> > 
> > http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.git/tree/inclu
> 
> So there actually exists some tests for futexes, I've been asked if we
> have these as a LTP[1] maintainer several times.
> 
> Are these tests executed regulary as a part of some automated framework?
> If not it would make sense to port them to LTP (looking at the code that
> would be quite easy task) and get them executed by several QA
> departments for free. What do you think?
> 
> [1] http://linux-test-project.github.io/
> 

I think Thomas may be working on one. If not, I'd be happy to start
writing one as well.

-- Steve
