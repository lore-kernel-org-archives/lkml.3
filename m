Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab3GRKrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:47:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59432 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab3GRKrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:47:20 -0400
Date: Thu, 18 Jul 2013 12:47:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Hunter <ahh@google.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [RFC] [PATCH] x86: avoid per_cpu for APIC id tables
Message-ID: <20130718104711.GM27075@twins.programming.kicks-ass.net>
References: <1374090073-1957-1-git-send-email-ahh@google.com>
 <20130718065249.GA17622@gmail.com>
 <20130718085542.GE27075@twins.programming.kicks-ass.net>
 <20130718104527.GE23558@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130718104527.GE23558@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 18, 2013 at 12:45:27PM +0200, Ingo Molnar wrote:
> > While one could base the code (or even share) it with pipe, I'd like it 
> > to appear a different benchmark from the outside. Also I'm fairly sure 
> > they have a benchmark for this. Venki started this work, it looks like 
> > Andrew is taking over, good! :-)
> 
> Do you mean it should be in a separate 'perf bench sched remote-wakeup' 
> benchmark, appearing as a separate benchmark to the user? Agreed with 
> that.

Yes, exactly that.
