Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934312Ab3CHP3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 10:29:35 -0500
Received: from mail.active-venture.com ([67.228.131.205]:65532 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934274Ab3CHP3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 10:29:34 -0500
X-Originating-IP: 108.223.40.66
Date: Fri, 8 Mar 2013 07:29:34 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>, Ingo Molnar <mingo@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2] early_printk: consolidate random copies of identical
 code
Message-ID: <20130308152934.GA18274@roeck-us.net>
References: <1362683754-706-1-git-send-email-paul.gortmaker@windriver.com>
 <20130307112536.82288f41924a38a441cdf345@linux-foundation.org>
 <5138EF7F.1050003@windriver.com>
 <20130307133542.8bdb23612990fa25c5cc9112@linux-foundation.org>
 <20130308011042.GE9161@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130308011042.GE9161@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 08:10:43PM -0500, Steven Rostedt wrote:
> On Thu, Mar 07, 2013 at 07:49:35PM -0500, Paul Gortmaker wrote:
> > 
> > Within an hour, Fengguang's robots[1] found the branch, were compiling
> > it for fringe architectures, and running sparse on it, and sending me the
> > sparse regressions.  I'd listened to Fengguang's presentation while at
> > KS in San Diego, but I had no idea it was this proactive, until it did
> > autobot testing on my branch.
> 
> And people wonder why I wanted to give Fengguang a round of applauds
> there. I guess I was one of the first people to get his testing, as it
> found a lot of little things for me that my own tests missed.
> 
> > 
> > I have most of the prebuilt toolchains[2], and two line wrappers to set
> > the ARCH/CROSS_COMPILE, but as it stands, it seems I really don't
> > need those any more.  I can sanity test on a common arch and then
> > simply push to kernel.org to trigger build sanity across all arch.  I'll
> > probably still continue to use the toolchain prebuilts to test locally
> > though, just for the peace of mind.  But knowing FW bots are doing
> > testing before it goes into linux-next or anywhere else is really nice.
> > 
> 
> I should stress that there's a sample ktest.pl file for everyone:
> 
>  tools/testing/ktest/examples/crosstests.conf
> 
> Just download the cross compilers from:
> 
>  (assuming you're running on an x86_64 box)
> 
>   https://www.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.6.3/
> 
Have you tried that link recently ?

I get:

Forbidden

You don't have permission to access /pub/tools/crosstool/files/bin/x86_64/4.6.3/
on this server.

Guenter
