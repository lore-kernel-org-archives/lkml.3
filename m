Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab3F0Mom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:44:42 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:39334 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab3F0Moh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:44:37 -0400
Date: Thu, 27 Jun 2013 05:44:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC nohz_full 0/8] Provide infrastructure for full-system
 idle
Message-ID: <20130627124424.GW3828@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130625213721.GA19452@linux.vnet.ibm.com>
 <20130626122022.GI28407@twins.programming.kicks-ass.net>
 <20130626222442.GU3828@linux.vnet.ibm.com>
 <20130627094226.GP28407@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627094226.GP28407@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062712-7606-0000-0000-00000CD52AE3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 11:42:26AM +0200, Peter Zijlstra wrote:
> On Wed, Jun 26, 2013 at 03:24:42PM -0700, Paul E. McKenney wrote:
> > Just to make sure I understand...  You are saying that it is OK for
> > NO_HZ_FULL to shut down timekeeping if all CPUs are idle, even if some
> > of them are taking NMIs from time to time, right?
> 
> Yeah.. its what we currently do and I don't see any reason to have
> NO_HZ_FULL behave differently there.

Whew!!!  ;-)

							Thanx, Paul

