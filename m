Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab3KVSya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 13:54:30 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:35385 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab3KVSy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 13:54:27 -0500
Date: Fri, 22 Nov 2013 10:54:22 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH v2 RFC 1/3] documentation: Add needed ACCESS_ONCE() calls
 to memory-barriers.txt
Message-ID: <20131122185421.GY4138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131121213055.GA6938@linux.vnet.ibm.com>
 <1385069489-7898-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20131121215517.GA16796@laptop.programming.kicks-ass.net>
 <20131121220950.GG4138@linux.vnet.ibm.com>
 <20131121221821.GB16796@laptop.programming.kicks-ass.net>
 <20131121223230.GI4138@linux.vnet.ibm.com>
 <20131122111723.GK10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122111723.GK10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112218-3532-0000-0000-0000034016DD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 12:17:23PM +0100, Peter Zijlstra wrote:
> On Thu, Nov 21, 2013 at 02:32:30PM -0800, Paul E. McKenney wrote:
> 
> > > > We could, but at the moment I would prefer the decrease in readability
> > > > to the copy-and-paste bugs that omit needed ACCESS_ONCE() calls.
> > > > 
> > > > Is there some way to get both ACCESS_ONCE() and readability?  An
> > > > abbreviation such as AO()?  More easily distinguished variable names?
> > > > Something else?
> > > 
> > > Use a form that looks less like C and thus defeats copy/paste?
> > 
> > My concern with that approach is that there is likely to be a large
> > number of people who are likely to be willing and able to transcribe
> > from any reasonable non-C form to ACCESS_ONCE()-free C code.  :-/
> > 
> > But maybe you have something specific in mind?
> 
> No, that was pretty much it. My issues is though that the subject matter
> is difficult enough without actively obfuscating the examples.
> 
> Furthermore, people will find ways to get it wrong anyhow, if all they
> do is copy/paste without thought, then getting it wrong is pretty much
> guaranteed in this case. Memory ordering isn't something you can do
> without thinking.

One could argue that parsing the ACCESS_ONCE() calls will help them
realize that they actually need to think.  ;-)

							Thanx, Paul

