Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365AbaJ2R70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:59:26 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:62552 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559AbaJ2R7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:59:24 -0400
MIME-Version: 1.0
In-Reply-To: <20141028215937.GA25095@linux.vnet.ibm.com>
References: <20141028215937.GA25095@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Wed, 29 Oct 2014 13:58:53 -0400
Message-ID: <CAJhHMCDf1vTuQ5-31aumFPVsyTTFYyioDjvoT7xDobC5vVUHMA@mail.gmail.com>
Subject: Re: [PATCH tip/core/rcu 0/5] Documentation updates for 3.19
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, dvhart@linux.intel.com,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 5:59 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> Hello!
>
> This series contains a few documentation updates:
>
> 1.      Records limitations of bitfields and small variables.
>         Also rules out pre-EV56 Alpha, which lack 8- and 16-bit
>         memory-reference instructions.  Later Alpha CPUs are OK.
>         (The official Alpha maintainers have thus far been silent
>         on this patch.)
>
> 2.      Document the new RCU self-test boot parameters, courtesy of
>         Pranith Kumar.
>
> 3.      Records that short-circuit boolean evaluation does not necessarily
>         defend against control-dependency breakage by compiler optimizations.
>
> 4.      Add mention of atomic_long_t to atomic_ops.txt.
>
> 5.      Fix an example in memory-barriers.txt, courtesy of Pranith Kumar.


Reviewed-by: Pranith Kumar <bobby.prani@gmail.com>

>
>                                                         Thanx, Paul
>
> ------------------------------------------------------------------------
>
>  b/Documentation/atomic_ops.txt        |   12 +++--
>  b/Documentation/kernel-parameters.txt |    9 ++++
>  b/Documentation/memory-barriers.txt   |   71 ++++++++++++++++++++++++++++------
>  3 files changed, 77 insertions(+), 15 deletions(-)
>



-- 
Pranith
