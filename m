Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbaEOP2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 11:28:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50710 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbaEOP2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 11:28:43 -0400
Date: Thu, 15 May 2014 17:28:35 +0200
From: chrubis@suse.cz
To: Darren Hart <dvhart@linux.intel.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux API <linux-api@vger.kernel.org>,
        "Carlos O'Donell" <carlos@redhat.com>
Subject: Re: futex(2) man page update help request
Message-ID: <20140515152834.GA6926@rei.Home>
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CF98E3EF.90564%dvhart@linux.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
> 
> However, unless I'm sorely mistaken, the larger problem is that glibc
> removed the futex() call entirely, so these man pages don't describe
> something users even have access to anymore. I had to revert to calling
> the syscalls directly in the futextest test suite because of this:
> 
> http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.git/tree/inclu

So there actually exists some tests for futexes, I've been asked if we
have these as a LTP[1] maintainer several times.

Are these tests executed regulary as a part of some automated framework?
If not it would make sense to port them to LTP (looking at the code that
would be quite easy task) and get them executed by several QA
departments for free. What do you think?

[1] http://linux-test-project.github.io/

-- 
Cyril Hrubis
chrubis@suse.cz
