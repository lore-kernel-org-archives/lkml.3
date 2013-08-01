Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab3HAHsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 03:48:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45523 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab3HAHst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 03:48:49 -0400
Date: Thu, 1 Aug 2013 09:48:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        KML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        aswin@hp.com, scott.norton@hp.com, chegu_vinod@hp.com,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH] sched: Reduce overestimating avg_idle
Message-ID: <20130801074829.GH3008@twins.programming.kicks-ass.net>
References: <1375263472.3922.26.camel@j-VirtualBox>
 <51F9349A.3090605@redhat.com>
 <1375342601.1974.104.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375342601.1974.104.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 12:36:41AM -0700, Jason Low wrote:
> So how acceptable is setting a limit of 2*migration cost or less on the
> delta rather than on the avg?

Its fine with me as we're already doing that. But since you asked last
time around if those two things weren't unrelated etc.. 
