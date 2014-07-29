Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbaG2LdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 07:33:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:35868 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbaG2LdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:33:11 -0400
Date: Tue, 29 Jul 2014 13:33:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 02/10] nohz: Kick full dynticks timer targets with an
 empty IPI
Message-ID: <20140729113307.GW3935@laptop>
References: <1406569056-30217-1-git-send-email-fweisbec@gmail.com>
 <1406569056-30217-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406569056-30217-3-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 07:37:28PM +0200, Frederic Weisbecker wrote:
>  	if (tick_nohz_full_cpu(cpu)) {
>  		if (cpu != smp_processor_id() ||
>  		    tick_nohz_tick_stopped())

Not really a comment on this patch per-se, but why is that line broken?
If I concat them its only 74 chars long.

> +			kick_cpu_async(cpu);
>  		return true;
>  	}
