Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030279AbaDJO2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 10:28:50 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:62270 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935077AbaDJO2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 10:28:47 -0400
Message-ID: <1397140123.5137.99.camel@marge.simpson.net>
Subject: Re: [RFC PATCH RT] rwsem: The return of multi-reader PI rwsems
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <williams@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Date: Thu, 10 Apr 2014 16:28:43 +0200
In-Reply-To: <1397139510.5137.92.camel@marge.simpson.net>
References: <20140409151922.5fa5d999@gandalf.local.home>
	 <1397139510.5137.92.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-04-10 at 16:18 +0200, Mike Galbraith wrote: 
> On Wed, 2014-04-09 at 15:19 -0400, Steven Rostedt wrote:
> 
> > If you have any benchmark on large machines I would be very happy if
> > you could test this patch against the unpatched version of -rt.
> 
> Too bad I don't have (and know how to use) specjbb.
> 
> I dug up old vmark, thinking I'd be able to get some halfway useful
> relative numbers from it, but that was a waste of a day.  The thing
> performs so badly on 40 core box that rt _beats_ nopreempt, and after 2
> nodes, you're going backward.  40 Westmere EX cores does a whopping ~2.5
> * dinky old Q6600 box throughput.

P.S.  What I didn't see was any sign of a delta patched/unpatched..
which may mean nothing at all :-/

