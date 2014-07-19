Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbaGSTpl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 15:45:41 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57098 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaGSTpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 15:45:40 -0400
Date: Sat, 19 Jul 2014 21:45:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 07/10] nohz: Enforce timekeeping on CPU 0
Message-ID: <20140719194525.GT9918@twins.programming.kicks-ass.net>
References: <1405730661-9355-1-git-send-email-fweisbec@gmail.com>
 <1405730661-9355-8-git-send-email-fweisbec@gmail.com>
 <alpine.LFD.2.11.1407191318320.3647@knanqh.ubzr>
 <20140719183132.GK3935@laptop>
 <alpine.LFD.2.11.1407191442100.3647@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1407191442100.3647@knanqh.ubzr>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2014 at 02:46:56PM -0400, Nicolas Pitre wrote:
> People think all sorts of things.  And it becomes very irritating when 
> thoughtful assumptions get burned into ROM for example.  We should be 
> able to do better in the kernel.

Agreed. There used to be an x86 subarch where the boot cpu wasn't cpu0,
that always gave a lot of 'joy' too :-)
