Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbaHZSQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 14:16:57 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39870 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753383AbaHZSQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 14:16:55 -0400
Date: Tue, 26 Aug 2014 19:16:14 +0100
From: Will Deacon <will.deacon@arm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        "akpm@linuxfoundation.org" <akpm@linuxfoundation.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>
Subject: Re: [PATCH 19/35] [PATCH 19/36] arm: Replace __this_cpu_ptr with
 raw_cpu_ptr
Message-ID: <20140826181614.GH23445@arm.com>
References: <20140817173023.439660246@linux.com>
 <20140817173035.870898843@linux.com>
 <20140826181131.GB31659@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140826181131.GB31659@mtj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 07:11:31PM +0100, Tejun Heo wrote:
> On Sun, Aug 17, 2014 at 12:30:42PM -0500, Christoph Lameter wrote:
> > __this_cpu_ptr is being phased out. So replace with raw_cpu_ptr.
> > 
> > Cc: Russell King <linux@arm.linux.org.uk>
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > CC: Will Deacon <will.deacon@arm.com>
> > Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> (Please disregard the ones I posted for v1 of the patch series)
> 
> Applied to percpu/for-3.18-consistent-ops with Will's ack added.
> Please let me know if this patch should be routed differently.  Note
> that this patch was to be applied to percpu/for-3.17 but delayed due
> to build issues caused by cpumask_var_t.

I was going to send it via RMK, but I'm happy either way.

Will
