Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab3IKQDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 12:03:31 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:38655 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab3IKQDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 12:03:30 -0400
Date: Wed, 11 Sep 2013 09:03:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130911160315.GB3966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130909165836.GB3966@linux.vnet.ibm.com>
 <20130909172908.GA31239@Krystal>
 <20130909175656.GF3966@linux.vnet.ibm.com>
 <20130909214026.GA8830@Krystal>
 <20130909175917.794b19bd@gandalf.local.home>
 <20130909223426.GM3966@linux.vnet.ibm.com>
 <20130911141302.GA11342@linux.vnet.ibm.com>
 <20130911102607.16a3da91@gandalf.local.home>
 <20130911152331.GZ3966@linux.vnet.ibm.com>
 <20130911114916.4a53f9f0@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911114916.4a53f9f0@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091116-7164-0000-0000-00000189BFAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 11:49:16AM -0400, Steven Rostedt wrote:
> On Wed, 11 Sep 2013 08:23:31 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > C'mon, Steven!  I did say "after treating injuries"!  In the opinion
> > of the surgeon, the only option was to ampute what was left of either
> > the _cpu(), _task(), _thread(), or _you().  Heck, the damage was so
> > severe that we couldn't even tell which one it was!
> 
> What a morbid thought. The possibility that "_you" was amputated.

;-) ;-) ;-)

							Thanx, Paul

