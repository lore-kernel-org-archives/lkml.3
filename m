Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823Ab3FROly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 10:41:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058Ab3FROlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 10:41:53 -0400
Date: Tue, 18 Jun 2013 10:40:20 -0400
From: Dave Jones <davej@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com,
        mingo@kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Another RCU trace. (3.10-rc5)
Message-ID: <20130618144020.GB1313@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com,
	mingo@kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <20130610195145.GA26068@redhat.com>
 <20130610203355.GO5146@linux.vnet.ibm.com>
 <20130610210123.GA27154@redhat.com>
 <1370899008.9844.126.camel@gandalf.local.home>
 <20130618095821.GJ3204@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618095821.GJ3204@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 11:58:21AM +0200, Peter Zijlstra wrote:

 > > Peter, Are you going to take the preempt_schedule_context() patch?
 > 
 > I have it queued, I just seem to have some problems locating Ingo to
 > stuff patches into -tip :/
 > 
 > Will continue prodding.. Ingo if you're reading! :-)

There's a bunch of other stuff in tip pending pushing to Linus too,
including a bunch of fixes in timers/urgent that have been there
over a month.

Ingo hasn't posted since the 3rd, maybe he's sick/on vacation.
Does anyone else do pushes from tip->Linus ?  tglx ?

	Dave

