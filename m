Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab3FRMx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:53:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43980 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab3FRMx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 08:53:57 -0400
Date: Tue, 18 Jun 2013 14:53:39 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Anish Singh <anish198519851985@gmail.com>, eranian@google.com
Subject: Re: [PATCH 4/6] watchdog: Boot-disable by default on full dynticks
Message-ID: <20130618125339.GC28407@twins.programming.kicks-ass.net>
References: <1371045758-5296-1-git-send-email-fweisbec@gmail.com>
 <1371045758-5296-5-git-send-email-fweisbec@gmail.com>
 <20130612170316.GO133453@redhat.com>
 <20130613131057.GA15997@somewhere>
 <20130613140207.GW133453@redhat.com>
 <20130618103632.GO3204@twins.programming.kicks-ass.net>
 <20130618120436.GA17619@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618120436.GA17619@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 02:04:38PM +0200, Frederic Weisbecker wrote:
> I see. So what do you think, should I push my patch that deactivates
> the watchdog to Ingo until this below patch gets ready? It would be nice to
> have a solution for 3.11.

I don't care too much either way.

> If you prefer I can work on getting your below proposal into shape. I'm on
> vacancies next week but I can try to get it ready until the next merge window
> closes.

Right, except for some 'fun' details the proposed patch isn't actually
that hard. Enjoy your holidays.
