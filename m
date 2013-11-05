Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab3KENSn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 08:18:43 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:7516 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754331Ab3KENSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 08:18:42 -0500
Date: Tue, 5 Nov 2013 08:18:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, oleg@redhat.com, dhowells@redhat.com,
        willy@linux.intel.com, tglx@linutronix.de, airlied@gmail.com,
        maarten.lankhorst@canonical.com, walken@google.com,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC 0/8] Move locking primitives into kernel/locking/
Message-ID: <20131105081838.27c7fcd4@gandalf.local.home>
In-Reply-To: <20131105105244.666320103@infradead.org>
References: <20131105105244.666320103@infradead.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Nov 2013 13:10:44 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> Hi all,
> 
> During Kernel Summit Dave mentioned that there wasn't a clear maintainer for
> locking bits.
> 
> To remedy this Ingo suggested gathering all the various locking primitives and
> lockdep into a single place: kernel/locking/.
> 
> I would further like to propose a MAINTAINERS entry like:
> 
> LOCKING
> M:      Ingo Molnar <mingo@redhat.com>
> M:      Peter Zijlstra <peterz@infradead.org>
> M:	Oleg Nesterov <oleg@redhat.com>
> M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> M:	Linus Torvalds <torvalds@linux-foundation.org>
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git locking/core
> S:      Maintained
> F:      kernel/locking/

I wonder if it should be called kernel/locks, as that's less to type,
smaller path names, and tastes good on bagels.

-- Steve

> 
> Because for most 'fun' locking discussions we usually end up with at least
> those people anyway :-)
> 
