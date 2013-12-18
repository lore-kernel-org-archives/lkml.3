Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab3LROTE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:19:04 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:53248 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab3LROTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:19:01 -0500
Date: Wed, 18 Dec 2013 06:18:55 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Alex Shi <alex.shi@linaro.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [RFC PATCH 00/13] nohz: Use sysidle detection to let the
 timekeeper sleep
Message-ID: <20131218141855.GO19211@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
 <52B102BB.1050907@linaro.org>
 <20131218101912.GQ13532@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218101912.GQ13532@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121814-3532-0000-0000-000003F4382A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 11:19:12AM +0100, Peter Zijlstra wrote:
> On Wed, Dec 18, 2013 at 10:04:43AM +0800, Alex Shi wrote:
> > On 12/18/2013 06:51 AM, Frederic Weisbecker wrote:
> > Thanks Fredic!
> > It is much better on powersaving POV compare to current nohz_full. :)
> 
> If you're using nohz_full for powersaving, you're doing it wrong.

They just want nohz_full not to totally break powersavings when the
entire system is idle.  ;-)

							Thanx, Paul

