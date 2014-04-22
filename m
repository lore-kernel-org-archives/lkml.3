Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933534AbaDVRjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 13:39:08 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:18610 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932927AbaDVRjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 13:39:05 -0400
Date: Tue, 22 Apr 2014 10:38:54 -0700
From: Drew Richardson <drew.richardson@arm.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Ben Greear <greearb@candelatech.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] Export irq tracepoints for use by kernel modules
Message-ID: <20140422173854.GA26894@dreric01-Precision-T1600>
References: <20140422142419.GD21121@dreric01-Precision-T1600>
 <20140422142613.GA14535@infradead.org>
 <CA+5PVA7TFXdK-KjbwUtqMPF6=Ot1yhKycg5naV6N_gALWVN7cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA7TFXdK-KjbwUtqMPF6=Ot1yhKycg5naV6N_gALWVN7cg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 04:01:03PM +0100, Josh Boyer wrote:
> On Tue, Apr 22, 2014 at 10:26 AM, Christoph Hellwig <hch@infradead.org> wrote:
> > On Tue, Apr 22, 2014 at 07:24:20AM -0700, Drew Richardson wrote:
> >> After commit de7b2973903c6cc50b31ee5682a69b2219b9919d ("tracepoint:
> >> Use struct pointer instead of name hash for reg/unreg tracepoints"),
> >> any tracepoints used in a kernel module must be exported.
> >
> > How does this matter given that there aren't any modular users?
> 
> We had a bug report about this breaking systemtap type usage[1].  In
> there, Matthieu suggested that the new for_each_kernel_tracepoint
> interface be used.
> 
> Drew, it would have been proper to CC the author of the change you're
> referencing on all of your patches to export these symbols.
> 
> josh
> 
> [1] https://bugzilla.redhat.com/show_bug.cgi?id=1087623
> 

Thanks Josh for pointing out that I should CC Mathieu and
register_tracepoint_module_notifier, which will work for me.

Drew
