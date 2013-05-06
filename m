Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab3EFJ1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 05:27:04 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:36240 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab3EFJ1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 05:27:03 -0400
Date: Mon, 6 May 2013 11:26:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 0/2] sched: move content out of core files for load
 calculations
Message-ID: <20130506092657.GA9227@gmail.com>
References: <1366398650-31599-1-git-send-email-paul.gortmaker@windriver.com>
 <20130421091846.GE31470@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130421091846.GE31470@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> 
> > Recent activity has had a focus on moving functionally related blocks of
> > stuff out of sched/core.c into stand-alone files.  The code relating to load
> > calculations has grown significantly enough recently to warrant placing it in
> > a separate file.
> > 
> > Here we do that, and in doing so, we shed ~20k of code from sched/core.c (~10%).
> > 
> > A couple small static functions in the core sched.h header were also localized
> > to their singular user in sched/fair.c at the same time, with the goal to also
> > reduce the amount of "broadcast" content in that sched.h file.
> > 
> > Paul.
> > ---
> > 
> > v2 changes:
> > 
> >   1) rebase from tip's sched/core (v3.9-rc1-38-gb329fd5) to today's
> >      tip master (v3.9-rc6-2031-g27f8b76).
> >   2) rename file from load_avg.c to proc.c
> 
> Thanks, looks good to me. Note, I'll try to apply this after the initial 
> round of trees went to Linus in the merge window, to reduce interactions 
> between the trees. [...]

Ok, all relevant trees are now upstream - mind sending a refreshed series 
against upstream merge commit 534c97b0950b or later?

Thanks,

	Ingo
