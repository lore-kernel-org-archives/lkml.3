Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab3KVQIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:08:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49685 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532Ab3KVQIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:08:48 -0500
Date: Fri, 22 Nov 2013 17:08:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <bitbucket@online.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] rtmutex: take the waiter lock with irqs off
Message-ID: <20131122160841.GS3866@twins.programming.kicks-ass.net>
References: <1383798668.5441.25.camel@marge.simpson.net>
 <alpine.DEB.2.02.1311071158350.23353@ionos.tec.linutronix.de>
 <20131107125923.GB24644@localhost.localdomain>
 <alpine.DEB.2.02.1311071402380.23353@ionos.tec.linutronix.de>
 <1384243595.15180.63.camel@marge.simpson.net>
 <alpine.DEB.2.02.1311121024590.30673@ionos.tec.linutronix.de>
 <20131115163008.GB12164@linutronix.de>
 <20131115201436.GC12164@linutronix.de>
 <20131118141021.GA10022@twins.programming.kicks-ass.net>
 <20131122135931.GA8698@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122135931.GA8698@linutronix.de>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 02:59:31PM +0100, Sebastian Andrzej Siewior wrote:
> +extern void __lockfunc rt_spin_try_unlock(spinlock_t *lock);

I know what you mean, but.. try_unlock() just sounds wrong, how can we
attempt but fail to unlock a lock we hold ;-)


/me crawls back under his rock ;-)
