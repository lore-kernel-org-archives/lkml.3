Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaHZSTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 14:19:11 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:35693 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbaHZSTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 14:19:10 -0400
Date: Tue, 26 Aug 2014 14:19:04 -0400
From: Tejun Heo <tj@kernel.org>
To: Will Deacon <will.deacon@arm.com>
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
Message-ID: <20140826181904.GR31659@mtj.dyndns.org>
References: <20140817173023.439660246@linux.com>
 <20140817173035.870898843@linux.com>
 <20140826181131.GB31659@mtj.dyndns.org>
 <20140826181614.GH23445@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140826181614.GH23445@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 07:16:14PM +0100, Will Deacon wrote:
> > Applied to percpu/for-3.18-consistent-ops with Will's ack added.
> > Please let me know if this patch should be routed differently.  Note
> > that this patch was to be applied to percpu/for-3.17 but delayed due
> > to build issues caused by cpumask_var_t.
> 
> I was going to send it via RMK, but I'm happy either way.

Yeah, I think it'd be easier to route this through percpu tree.  There
are too many of these and a dependent change follows afterwards.

Thanks!

-- 
tejun
