Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932892Ab3LDQms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 11:42:48 -0500
Received: from a9-112.smtp-out.amazonses.com ([54.240.9.112]:34433 "EHLO
	a9-112.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932729Ab3LDQmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 11:42:47 -0500
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Dec 2013 11:42:47 EST
Date: Wed, 4 Dec 2013 16:37:32 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [PATCH 22/41] rcu: Replace __this_cpu_ptr uses with
 raw_cpu_ptr
In-Reply-To: <20131204011255.GB15492@linux.vnet.ibm.com>
Message-ID: <00000142be78bbff-3b76f181-9754-4532-b4c6-c6760e2a4964-000000@email.amazonses.com>
References: <20131203233232.928771708@linux.com> <20131203233256.509969629@linux.com> <20131204011255.GB15492@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.04-54.240.9.112
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Dec 2013, Paul E. McKenney wrote:

> This does not build on 3.13-rc2.  Ah, need a couple of patches earlier
> in the series.
>
> But...  But...  Didn't we recently change -to- __this_cpu_ptr() from
> the older __get_cpu_var()?

We moved from __get_cpu_var to this_cpu_ptr in a earlier patch proposal.
The __this_cpu_ptrs were then decided to have to be called raw_cpu_ptr.
You merged patch from the proposal. The patch was merged a bit too
early into your tree.
