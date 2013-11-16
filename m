Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab3KPL76 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 06:59:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab3KPL7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 06:59:51 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1384560630-28719-4-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1384560630-28719-4-git-send-email-paulmck@linux.vnet.ibm.com> <20131116001005.GA28191@linux.vnet.ibm.com> <1384560630-28719-1-git-send-email-paulmck@linux.vnet.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 4/4] documentation: Update circular buffer for load-acquire/store-release
Date: Sat, 16 Nov 2013 11:58:45 +0000
Message-ID: <13351.1384603125@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> -		/* read index before reading contents at that index */

> -		smp_mb(); /* finish reading descriptor before incrementing tail */

I'd rather you didn't remove these comments (assuming they're correct) as
they're pointing out the point of the example.

David
