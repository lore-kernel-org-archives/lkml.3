Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaGaQtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:49:13 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:37436 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaGaQtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:49:11 -0400
Date: Thu, 31 Jul 2014 09:49:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: josh@joshtriplett.org, linux-kernel@vger.kernel.org, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, tglx@linutronix.de,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: Re: [PATCH v2 tip/core/rcu 0/10] RCU-tasks implementation
Message-ID: <20140731164904.GU11241@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140731003914.GA3872@linux.vnet.ibm.com>
 <20140731161902.GA12697@cloud>
 <20140731163012.GA19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731163012.GA19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073116-0928-0000-0000-000003C1FFE5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 06:30:12PM +0200, Peter Zijlstra wrote:
> On Thu, Jul 31, 2014 at 09:19:02AM -0700, josh@joshtriplett.org wrote:
> > Also, ideally this should remain entirely optional; nothing in the core
> > kernel should depend on it.
> 
> I suspect Steve wants it for ftrace :-)

This is my guess as well.  ;-)

Steven should be back next week, and perhaps we will learn more then.

							Thanx, Paul

