Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbaGHNUD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:20:03 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:40757 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376AbaGHNUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:20:00 -0400
Date: Tue, 8 Jul 2014 06:19:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC tip/core/rcu] Parallelize and economize NOCB kthread
 wakeups
Message-ID: <20140708131954.GE4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140627142038.GA22942@linux.vnet.ibm.com>
 <20140702123412.GD19379@twins.programming.kicks-ass.net>
 <20140702153915.GQ4603@linux.vnet.ibm.com>
 <20140702160412.GO19379@twins.programming.kicks-ass.net>
 <20140702170838.GS4603@linux.vnet.ibm.com>
 <20140702172600.GR19379@twins.programming.kicks-ass.net>
 <20140702175501.GW4603@linux.vnet.ibm.com>
 <20140703095009.GN3935@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140703095009.GN3935@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070813-0928-0000-0000-00000333B420
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 11:50:09AM +0200, Peter Zijlstra wrote:
> On Wed, Jul 02, 2014 at 10:55:01AM -0700, Paul E. McKenney wrote:
> > Name me one thing that isn't annoying.  ;-)
> 
> A cold beverage on a warm day :-)

Fair point...  Not clear how to work that into the RCU implementation,
though.  I suppose I could add comments instructing the reader to consume
a cold beverage.  Or I could consume a cold beverage while working on
RCU.  ;-)

							Thanx, Paul

