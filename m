Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaLOPLE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 10:11:04 -0500
Received: from www.linutronix.de ([62.245.132.108]:44895 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaLOPLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 10:11:01 -0500
Date: Mon, 15 Dec 2014 16:10:51 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/2 v2] tracing: Enable tracepoints early and allow printk
 to use them
In-Reply-To: <20141214201609.126831471@goodmis.org>
Message-ID: <alpine.DEB.2.11.1412151610050.17382@nanos>
References: <20141214201609.126831471@goodmis.org>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Dec 2014, Steven Rostedt wrote:
> As the merge window is still open, and this code was not as complex
> as I thought it might be. I'm thinking of pushing this in now.
> 
> This will allow Thomas to debug his irq work for 3.20.
> 
> This code is not that intrusive and I'm currently running it through
> all my tests. But I like to have some more eyes on this, as I don't
> like to push something into mainline this quickly. I'm doing this only
> because the code is simple enough and is useful for work coming in 3.20.
> 
> I also feel that I could handle the fall out of this work over the
> holidays if need be.

Works like a charm. 

Tested-and-acked-by: Thomas Gleixner <tglx@linutronix.de>
