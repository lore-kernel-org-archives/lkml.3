Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309AbaALJlF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 04:41:05 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:56569 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaALJkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 04:40:45 -0500
Date: Sun, 12 Jan 2014 10:40:41 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC][PATCH] lockdep: Introduce wait-type checks
Message-ID: <20140112094041.GB31809@gmail.com>
References: <20140109111516.GE7572@laptop.programming.kicks-ass.net>
 <20140109163120.GA8038@redhat.com>
 <20140109170823.GF7572@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140109170823.GF7572@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> > But what I really can't understans is what "check == 0" means? It 
> > seems that in fact it can be 1 or 2? Or, iow, "check == 0" is 
> > actually equivalent to "check == 1" ?
> 
> Hmm indeed, the comment in lockdep.h says 0 means no checks at all, 
> but the code doesn't actually appear to work like that. I'm not sure 
> it ever did or not, I'd have to go dig through history.
> 
> That said, given the current state it certainly looks like we can 
> remove the check argument.
> 
> Ingo?

Agreed.

Thanks,

	Ingo
