Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279Ab3FRRci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 13:32:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51316 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728Ab3FRRch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 13:32:37 -0400
Date: Tue, 18 Jun 2013 19:32:27 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, fweisbec@gmail.com,
        mingo@kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Another RCU trace. (3.10-rc5)
Message-ID: <20130618173227.GE16094@twins.programming.kicks-ass.net>
References: <20130610195145.GA26068@redhat.com>
 <20130610203355.GO5146@linux.vnet.ibm.com>
 <20130610210123.GA27154@redhat.com>
 <1370899008.9844.126.camel@gandalf.local.home>
 <20130618095821.GJ3204@twins.programming.kicks-ass.net>
 <20130618144020.GB1313@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618144020.GB1313@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 10:40:20AM -0400, Dave Jones wrote:
> On Tue, Jun 18, 2013 at 11:58:21AM +0200, Peter Zijlstra wrote:
> 
>  > > Peter, Are you going to take the preempt_schedule_context() patch?
>  > 
>  > I have it queued, I just seem to have some problems locating Ingo to
>  > stuff patches into -tip :/
>  > 
>  > Will continue prodding.. Ingo if you're reading! :-)
> 
> There's a bunch of other stuff in tip pending pushing to Linus too,
> including a bunch of fixes in timers/urgent that have been there
> over a month.
> 
> Ingo hasn't posted since the 3rd, maybe he's sick/on vacation.
> Does anyone else do pushes from tip->Linus ?  tglx ?
> 

hpa and tglx are the other people with tip commit access. I'll try and
get a hold of tglx; he is currently at a conference but he should be
back the day after tomorrow.
