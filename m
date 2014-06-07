Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbaFGHb3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 03:31:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:39808 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbaFGHbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 03:31:25 -0400
Date: Sat, 7 Jun 2014 09:31:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Brad Mouring <bmouring@ni.com>
Subject: Re: [patch 2/2] rtmutex: Detect changes in the pi lock chain
In-Reply-To: <20140606104923.3020a352@gandalf.local.home>
Message-ID: <alpine.DEB.2.10.1406070930490.25930@nanos>
References: <20140605152544.641846795@linutronix.de> <20140605152801.930031935@linutronix.de> <20140606104923.3020a352@gandalf.local.home>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2014, Steven Rostedt wrote:
> On Thu, 05 Jun 2014 15:28:33 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
>  
> >  /**
> > @@ -764,7 +802,7 @@ __rt_mutex_slowlock(struct rt_mutex *loc
> >  }
> >  
> >  static void rt_mutex_handle_deadlock(int res, int detect_deadlock,
> > -				     struct rtmutex_waiter *w)
> > +				     struct rt_mutex_waiter *w)
> >  {
> >  	/*
> >  	 * If the result is not -EDEADLOCK or the caller requested
> > 
> 
> This needs to be folded in patch 1.

I know :) quilt refresh folded it automagically :)
