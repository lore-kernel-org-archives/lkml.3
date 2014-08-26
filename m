Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612AbaHZSCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 14:02:22 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:55533 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbaHZSCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 14:02:21 -0400
Date: Tue, 26 Aug 2014 14:02:17 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        James Hogan <james.hogan@imgtec.com>
Subject: Re: [PATCH 09/41] drivers/clocksource: Replace __get_cpu_var used
 for address calculation
Message-ID: <20140826180217.GH31659@mtj.dyndns.org>
References: <20131203233232.928771708@linux.com>
 <20131203233249.617496852@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203233249.617496852@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 05:32:41PM -0600, Christoph Lameter wrote:
> Replace __get_cpu_var used for address calculation with this_cpu_ptr.
> 
> Acked-by: James Hogan <james.hogan@imgtec.com>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Applied to percpu/for-3.18-consistent-ops.  Please let me know if this
patch should be routed differently.  Note that this patch was to be
applied to percpu/for-3.17 but delayed due to build issues caused by
cpumask_var_t.

Thanks.

-- 
tejun
