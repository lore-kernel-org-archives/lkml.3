Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab3LMN4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 08:56:51 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43247 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab3LMN4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 08:56:50 -0500
Date: Fri, 13 Dec 2013 14:56:26 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, rui.zhang@intel.com, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, paulmck@linux.vnet.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/15] cleanups and optimizations
Message-ID: <20131213135626.GL21999@twins.programming.kicks-ass.net>
References: <20131212140835.729222186@infradead.org>
 <52AAE61D.4060406@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AAE61D.4060406@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 12:49:01PM +0200, Eliezer Tamir wrote:
> On 12/12/2013 16:08, Peter Zijlstra wrote:
> > This series contains the preempt_enable_no_resched() cleanups that include
> > spin_lock_bh() optimizations and local_clock() optimizations.
> 
> I'm trying to test this on tip/master.
> Patch 3 fails to apply on kenrel/softirq.c

https://git.kernel.org/cgit/linux/kernel/git/peterz/queue.git/log/?h=preempt_clock

Applied just fine here.. stuffed it in a git tree.
