Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaFFOta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 10:49:30 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:56329 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751662AbaFFOt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 10:49:29 -0400
Date: Fri, 6 Jun 2014 10:49:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Brad Mouring <bmouring@ni.com>
Subject: Re: [patch 2/2] rtmutex: Detect changes in the pi lock chain
Message-ID: <20140606104923.3020a352@gandalf.local.home>
In-Reply-To: <20140605152801.930031935@linutronix.de>
References: <20140605152544.641846795@linutronix.de>
	<20140605152801.930031935@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Jun 2014 15:28:33 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:
 
>  /**
> @@ -764,7 +802,7 @@ __rt_mutex_slowlock(struct rt_mutex *loc
>  }
>  
>  static void rt_mutex_handle_deadlock(int res, int detect_deadlock,
> -				     struct rtmutex_waiter *w)
> +				     struct rt_mutex_waiter *w)
>  {
>  	/*
>  	 * If the result is not -EDEADLOCK or the caller requested
> 

This needs to be folded in patch 1.

-- Steve

