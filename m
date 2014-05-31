Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbaEaT4A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 15:56:00 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:24978 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753285AbaEaTz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 15:55:59 -0400
Date: Sat, 31 May 2014 15:55:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jason Low <jason.low2@hp.com>
Subject: Re: [patch v2 1/5] rtmutex: Remove builtin tester
Message-ID: <20140531155557.768b53f4@gandalf.local.home>
In-Reply-To: <20140531155739.175125650@linutronix.de>
References: <20140531155229.493650009@linutronix.de>
	<20140531155739.175125650@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2014 15:57:48 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> The tester has been broken for quite some time. It's possible to fix
> it, but the main reason for having it in the kernel was the lock steal
> mechanism in the rtmutex code. That's gone, so we can implement a
> stateful correctness tester just via the futex syscall.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>

I'm assuming that you only added what I said was missing. I didn't
re-review the rest of the patch.


Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Link: http://lkml.kernel.org/r/20140522031949.836503239@linutronix.de
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
