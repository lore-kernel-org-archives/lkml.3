Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbaHZSM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 14:12:29 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:50178 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbaHZSM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 14:12:28 -0400
Date: Tue, 26 Aug 2014 14:12:23 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 20/35] [PATCH 20/36] MIPS: Replace __get_cpu_var uses in
 FPU emulator.
Message-ID: <20140826181223.GD31659@mtj.dyndns.org>
References: <20140817173023.439660246@linux.com>
 <20140817173036.021525676@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140817173036.021525676@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2014 at 12:30:43PM -0500, Christoph Lameter wrote:
> The use of __this_cpu_inc() requires a fundamental integer type, so
> change the type of all the counters to unsigned long, which is the
> same width they were before, but not wrapped in local_t.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>
> Signed-off-by: Christoph Lameter <cl@linux.com>

(Please disregard the ones I posted for v1 of the patch series)

Applied to percpu/for-3.18-consistent-ops.  Please let me know if this
patch should be routed differently.  Note that this patch was to be
applied to percpu/for-3.17 but delayed due to build issues caused by
cpumask_var_t.

Thanks.

-- 
tejun
