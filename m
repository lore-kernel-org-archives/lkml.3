Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab3LRQnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 11:43:37 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:49883 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab3LRQng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 11:43:36 -0500
Date: Wed, 18 Dec 2013 17:43:33 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 10/13] nohz: Hand over timekeeping duty on cpu offlining
Message-ID: <20131218164330.GA19339@localhost.localdomain>
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
 <1387320692-28460-11-git-send-email-fweisbec@gmail.com>
 <20131218123001.GT13532@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218123001.GT13532@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 01:30:01PM +0100, Peter Zijlstra wrote:
> On Tue, Dec 17, 2013 at 11:51:29PM +0100, Frederic Weisbecker wrote:
> > The default timekeeper (aka CPU 0) is the perfect candidate for this
> > task since it can't be offlined itself.
> 
> Like said previously, yes it can!

I'll rephrase that in the changelog to precise that it's the tick hotplug handler
which prevent it to offline.
