Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934044Ab3JOUlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:41:37 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:52910 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933687Ab3JOUle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:41:34 -0400
Date: Tue, 15 Oct 2013 22:41:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: Re: [PATCH] bug: Use xchg() to update WARN_ON_ONCE() static variable
Message-ID: <20131015204129.GD3269@localhost.localdomain>
References: <20131015155806.04e2613f@gandalf.local.home>
 <20131015131259.3051743890ce9b1b9dae9763@linux-foundation.org>
 <20131015202134.GB3269@localhost.localdomain>
 <20131015163622.55181900@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015163622.55181900@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 04:36:22PM -0400, Steven Rostedt wrote:
> On Tue, 15 Oct 2013 22:21:36 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Oh, I have a pending patchset that I worked on a few weeks ago which does that.
> > I did not post it because it made WARN_ONCE using the unlikely text section, but
> > the diffstat was nice.
> > 
> > I'm going to post that as RFC just in case.
> 
> Oh well, I guess I don't need to work on that anymore ;-)

Well, the idea of setting __warned before the warning is still something we want
to fix seperately I think :)
