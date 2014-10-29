Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbaJ2CNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 22:13:40 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:50108 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaJ2CNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 22:13:38 -0400
MIME-Version: 1.0
In-Reply-To: <20141028221330.GA27479@linux.vnet.ibm.com>
References: <20141028221330.GA27479@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Tue, 28 Oct 2014 22:13:06 -0400
Message-ID: <CAJhHMCCmU5YytLqax_EqFfxYSwXDXvxWhkWPXPcC17_0hz=a3A@mail.gmail.com>
Subject: Re: [PATCH tip/core/rcu 0/2] Signal-related changes for 3.19
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

On Tue, Oct 28, 2014 at 6:13 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> Hello!
>
> This series updates RCU handling in signals:
>
> 1.      Prevents a possible very long RCU read-side critical section
>         in kill_pid_info().
>
> 2.      Explain why the "obviously buggy" freeing of sighand by
>         __cleanup_sighand() without an RCU grace period really isn't
>         buggy, courtesy of Oleg Nesterov.


Reviewed-by: Pranith Kumar <bobby.prani@gmail.com>

>
>                                                         Thanx, Paul
>
> ------------------------------------------------------------------------
>
>  b/kernel/fork.c   |    5 ++++-
>  b/kernel/signal.c |   42 +++++++++++++++++++++++++-----------------
>  2 files changed, 29 insertions(+), 18 deletions(-)
>



-- 
Pranith
