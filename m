Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423595Ab3FUUsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 16:48:15 -0400
Received: from mga14.intel.com ([143.182.124.37]:47919 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423350Ab3FUUsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 16:48:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,915,1363158000"; 
   d="scan'208";a="320749277"
Message-ID: <51C4BC09.3000708@linux.intel.com>
Date: Fri, 21 Jun 2013 13:48:09 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Subject: Re: [PATCH][GIT PULL] trace,x86: Move creation of irq tracepoints
 from apic.c to irq.c
References: <1371835898.18733.122.camel@gandalf.local.home>
In-Reply-To: <1371835898.18733.122.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 10:31 AM, Steven Rostedt wrote:
> 
> Peter,
> 
> I noticed that you pulled in Seiji's patches into tip. Last night I was
> running my test suite on them, and this morning they showed the
> following compile bug. I found the fix and attached it below. I pushed
> it into my tree that's based on your x86/trace branch, for your
> convenience.
> 
> My testing also triggered another bug, but I'm not sure it's related to
> these patches or something that already existed. I'm currently
> investigating it now.
> 
> -- Steve
> 
> 
> Please pull the latest tip/x86/trace tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/x86/trace
> 
> Head SHA1: 83ab85140bc1492f92de263a1c30ea04a0f465f7
> 

Thanks, pulled!

	-hpa


