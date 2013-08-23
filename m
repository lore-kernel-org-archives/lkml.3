Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab3HWKWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 06:22:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46649 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab3HWKWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 06:22:54 -0400
Date: Fri, 23 Aug 2013 12:22:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: mingo@redhat.com, gleb@redhat.com, glommer@parallels.com,
        tglx@linutronix.de, jeremy@goop.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove sched notifier for cross-cpu migrations
Message-ID: <20130823102230.GS31370@twins.programming.kicks-ass.net>
References: <20130710103440.GO25631@dyad.programming.kicks-ass.net>
 <20130711012157.GA21489@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130711012157.GA21489@amt.cnet>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 10:21:57PM -0300, Marcelo Tosatti wrote:
> 
> Linux as a guest on KVM hypervisor, the only user of the pvclock      
> vsyscall interface, does not require notification on task migration 
> because:
> 
> 1. cpu ID number maps 1:1 to per-CPU pvclock time info.
> 2. per-CPU pvclock time info is updated if the
>    underlying CPU changes.
> 3. that version is increased whenever underlying CPU 
>    changes.
> 
> Which is sufficient to guarantee nanoseconds counter
> is calculated properly.
> 
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

What happened to this patch? I don't see it in my current tree, nor do I
find it in the kvm tree.


