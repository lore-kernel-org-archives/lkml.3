Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbaGaQnu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:43:50 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:59550 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbaGaQns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:43:48 -0400
Date: Thu, 31 Jul 2014 09:43:41 -0700
From: josh@joshtriplett.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, tglx@linutronix.de,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com
Subject: Re: [PATCH v2 tip/core/rcu 0/10] RCU-tasks implementation
Message-ID: <20140731164341.GB12697@cloud>
References: <20140731003914.GA3872@linux.vnet.ibm.com>
 <20140731161902.GA12697@cloud>
 <20140731163012.GA19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140731163012.GA19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2014 at 06:30:12PM +0200, Peter Zijlstra wrote:
> On Thu, Jul 31, 2014 at 09:19:02AM -0700, josh@joshtriplett.org wrote:
> > Also, ideally this should remain entirely optional; nothing in the core
> > kernel should depend on it.
> 
> I suspect Steve wants it for ftrace :-)

Which can be compiled out. :)

- Josh Triplett
