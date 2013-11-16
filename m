Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab3KPQEj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 11:04:39 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44772 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3KPQEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 11:04:30 -0500
Date: Sat, 16 Nov 2013 17:03:40 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 4/4] documentation: Update circular buffer
 for load-acquire/store-release
Message-ID: <20131116160340.GM16796@laptop.programming.kicks-ass.net>
References: <20131116001005.GA28191@linux.vnet.ibm.com>
 <1384560630-28719-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1384560630-28719-4-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384560630-28719-4-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 04:10:30PM -0800, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> This commit replaces full barriers by targeted use of load-acquire and
> store-release.

I guess I'd better hurry up merging the patches that introduce these
thingies someplace :-)
