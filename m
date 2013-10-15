Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813Ab3JOUg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:36:28 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:13330 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933733Ab3JOUgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:36:24 -0400
Date: Tue, 15 Oct 2013 16:36:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: Re: [PATCH] bug: Use xchg() to update WARN_ON_ONCE() static
 variable
Message-ID: <20131015163622.55181900@gandalf.local.home>
In-Reply-To: <20131015202134.GB3269@localhost.localdomain>
References: <20131015155806.04e2613f@gandalf.local.home>
	<20131015131259.3051743890ce9b1b9dae9763@linux-foundation.org>
	<20131015202134.GB3269@localhost.localdomain>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Oct 2013 22:21:36 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Oh, I have a pending patchset that I worked on a few weeks ago which does that.
> I did not post it because it made WARN_ONCE using the unlikely text section, but
> the diffstat was nice.
> 
> I'm going to post that as RFC just in case.

Oh well, I guess I don't need to work on that anymore ;-)

-- Steve
