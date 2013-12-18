Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab3LROP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:15:57 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:38738 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab3LROPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:15:54 -0500
Date: Wed, 18 Dec 2013 06:15:49 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 03/13] rcu: Exclude all potential timekeepers from
 sysidle detection
Message-ID: <20131218141549.GN19211@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
 <1387320692-28460-4-git-send-email-fweisbec@gmail.com>
 <20131217232714.GD19211@linux.vnet.ibm.com>
 <20131217234913.GB18689@localhost.localdomain>
 <20131218114318.GR13532@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218114318.GR13532@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121814-0928-0000-0000-000004CE103A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 12:43:18PM +0100, Peter Zijlstra wrote:
> On Wed, Dec 18, 2013 at 12:49:15AM +0100, Frederic Weisbecker wrote:
> > That's to start simple as CPU 0 can't be offlined.
> 
> Yes it can, see CONFIG_BOOTPARAM_HOTPLUG_CPU0

Ah, and cpu0_hotplug boot parameter even if CONFIG_BOOTPARAM_HOTPLUG_CPU0=n.

Good to know!

							Thanx, Paul

