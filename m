Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab3A1PUB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:20:01 -0500
Received: from mail.skyhub.de ([78.46.96.112]:37086 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751Ab3A1PT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:19:58 -0500
Date: Mon, 28 Jan 2013 16:22:41 +0100
From: Borislav Petkov <bp@alien8.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Alex Shi <alex.shi@intel.com>, torvalds@linux-foundation.org,
        mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        namhyung@kernel.org, vincent.guittot@linaro.org,
        gregkh@linuxfoundation.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v4 0/18] sched: simplified fork, release load avg and
 power awareness scheduling
Message-ID: <20130128152241.GC6109@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@intel.com>,
	torvalds@linux-foundation.org, mingo@redhat.com,
	peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org,
	arjan@linux.intel.com, pjt@google.com, namhyung@kernel.org,
	vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
	preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
	linux-kernel@vger.kernel.org
References: <1359261385.5803.46.camel@marge.simpson.net>
 <20130127103508.GB8894@pd.tnic>
 <51052ACB.3070703@intel.com>
 <1359301903.5805.11.camel@marge.simpson.net>
 <1359350266.5783.39.camel@marge.simpson.net>
 <20130128095501.GB6109@pd.tnic>
 <1359369884.5783.117.camel@marge.simpson.net>
 <20130128112922.GA29384@pd.tnic>
 <1359372743.5783.136.camel@marge.simpson.net>
 <1359373246.5783.138.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1359373246.5783.138.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 12:40:46PM +0100, Mike Galbraith wrote:
> > No no, that's not restricted to one node.  It's just overloaded because
> > I turned balancing off at the NODE domain level.
> 
> Which shows only that I was multitasking, and in a rush.  Boy was that
> dumb.  Hohum.

Ok, let's take a step back and slow it down a bit so that people like me
can understand it: you want to try it with disabled load balancing on
the node level, AFAICT. But with that many tasks, perf will suck anyway,
no? Unless you want to benchmark the numa-aware aspect and see whether
load balancing on the node level feels differently, perf-wise?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
