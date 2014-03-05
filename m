Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbaCELDN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 06:03:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47542 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbaCELDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 06:03:12 -0500
Date: Wed, 5 Mar 2014 12:02:38 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [sched/idle] c365c292d05: ltp.sched_rr_get_interval02.1.TFAIL
Message-ID: <20140305110238.GS9987@twins.programming.kicks-ass.net>
References: <20140305015110.GJ8157@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305015110.GJ8157@localhost>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 09:51:10AM +0800, Fengguang Wu wrote:
> Hi Thomas,
> 
> We noticed ltp/syscalls test regression on
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched/idle
> 
> commit: c365c292d05908c6ea6f32708f331e21033fe71d ("sched: Consider pi boosting in setscheduler()")

Does: http://lkml.kernel.org/r/20140301191838.d15d03112b2598a671dac22c@gmail.com

Fix it?
