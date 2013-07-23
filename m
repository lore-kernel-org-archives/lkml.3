Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757358Ab3GWMdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 08:33:20 -0400
Received: from mout.gmx.net ([212.227.17.22]:50514 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756333Ab3GWMdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 08:33:19 -0400
Message-ID: <1374582790.30532.75.camel@marge.simpson.net>
Subject: Re: [RFC PATCH v2] sched: Limit idle_balance()
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, aswin@hp.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Date: Tue, 23 Jul 2013 14:33:10 +0200
In-Reply-To: <20130723120501.GY27075@twins.programming.kicks-ass.net>
References: <1374220211.5447.9.camel@j-VirtualBox>
	 <20130722070144.GC5138@linux.vnet.ibm.com>
	 <1374519467.7608.87.camel@j-VirtualBox>
	 <20130723110646.GA27005@linux.vnet.ibm.com>
	 <20130723120501.GY27075@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V03:K0:+kTf13v1ZguLunzgwtkRH9ZRYdampRlXW87/pIjzLGv29AO6vwA
 Or+g8ig82yRhoFdSDPFvFUn9cpPhGaHv9me5Yo+D032DHA5ImOxkI1sxzYYKlHrmA5hHWoO
 9klAIVVet/igLKlNq87YA599uEjH/YHXM2G5CPHItIleBD3Vnlaa1MqqztBq4PIPNaP0ofx
 9h0izKF3JGmAX+0GnQeZA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 14:05 +0200, Peter Zijlstra wrote: 
> On Tue, Jul 23, 2013 at 04:36:46PM +0530, Srikar Dronamraju wrote:
> 
> > May be the current max value is a limiting factor, but I think there
> > should be a limit to the maximum value. Peter and Ingo may help us
> > understand why they limited to the 1ms. But I dont think we should
> > introduce a new variable just for this.
> 
> /me blames it all on Mike.. I tried to remember why he did that, but
> alas.

Only to accelerate cutoff after long idle.

-Mike

