Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934980Ab3DOJdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 05:33:36 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:55199 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934577Ab3DOJdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 05:33:35 -0400
Date: Mon, 15 Apr 2013 11:33:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/2] sched: move content out of core files for load
 average
Message-ID: <20130415093330.GC17715@gmail.com>
References: <1365811457-31924-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365811457-31924-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Gortmaker <paul.gortmaker@windriver.com> wrote:

> Recent activity has had a focus on moving functionally related blocks of stuff 
> out of sched/core.c into stand-alone files.  The code relating to load average 
> calculations has grown significantly enough recently to warrant placing it in a 
> separate file.
> 
> Here we do that, and in doing so, we shed ~20k of code from sched/core.c (~10%).
> 
> A couple small static functions in the core sched.h header were also localized 
> to their singular user in sched/fair.c at the same time, with the goal to also 
> reduce the amount of "broadcast" content in that sched.h file.

Nice!

Peter, is this (and the naming of the new file) fine with you too?

Thanks,

	Ingo
