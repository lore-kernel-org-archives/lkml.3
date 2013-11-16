Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab3KPUTJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 15:19:09 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:55772 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab3KPUTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 15:19:00 -0500
Date: Sat, 16 Nov 2013 12:18:53 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 4/4] documentation: Update circular buffer
 for load-acquire/store-release
Message-ID: <20131116201853.GD4138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131116001005.GA28191@linux.vnet.ibm.com>
 <1384560630-28719-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1384560630-28719-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20131116160340.GM16796@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131116160340.GM16796@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111620-1542-0000-0000-0000035A5B33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 16, 2013 at 05:03:40PM +0100, Peter Zijlstra wrote:
> On Fri, Nov 15, 2013 at 04:10:30PM -0800, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > This commit replaces full barriers by targeted use of load-acquire and
> > store-release.
> 
> I guess I'd better hurry up merging the patches that introduce these
> thingies someplace :-)

+1 to that!  ;-)

							Thanx, Paul

