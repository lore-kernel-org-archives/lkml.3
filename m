Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbaHAC7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 22:59:40 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:63600 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaHAC7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 22:59:39 -0400
Message-ID: <1406861975.5319.5.camel@marge.simpson.net>
Subject: Re: [PATCH RFC tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, bobby.prani@gmail.com
Date: Fri, 01 Aug 2014 04:59:35 +0200
In-Reply-To: <20140731163819.GS11241@linux.vnet.ibm.com>
References: <20140728225556.GA19493@linux.vnet.ibm.com>
	 <1406588180-21933-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20140729081416.GR20603@laptop.programming.kicks-ass.net>
	 <20140729172304.GA16073@linux.vnet.ibm.com> <20140729173332.GM3935@laptop>
	 <20140729180656.GY11241@linux.vnet.ibm.com>
	 <1406726619.5889.17.camel@marge.simpson.net>
	 <20140730142311.GJ11241@linux.vnet.ibm.com>
	 <1406792228.6348.22.camel@marge.simpson.net>
	 <20140731163819.GS11241@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-07-31 at 09:38 -0700, Paul E. McKenney wrote:

> Does building with CONFIG_NO_HZ_FULL_SYSIDLE=y slow things down even more?
> If so, that would give me a rough idea of the cost of RCU's dyntick-idle
> handling.

Nope.  Deltas are all down in the statistical frog hair.

-Mike

