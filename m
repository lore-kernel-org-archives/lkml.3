Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbaHZSHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 14:07:39 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:36143 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbaHZSHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 14:07:36 -0400
Date: Tue, 26 Aug 2014 14:07:32 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 07/35] [PATCH 07/36] drivers/cpuidle: Replace
 __get_cpu_var uses for address calculation
Message-ID: <20140826180732.GP31659@mtj.dyndns.org>
References: <20140817173023.439660246@linux.com>
 <20140817173034.022788940@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140817173034.022788940@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2014 at 12:30:30PM -0500, Christoph Lameter wrote:
> All of these are for address calculation. Replace with
> this_cpu_ptr().
> 
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: linux-pm@vger.kernel.org
> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
> [cpufreq changes]
> Signed-off-by: Christoph Lameter <cl@linux.com>

(Please disregard the ones I posted for v1 of the patch series)

Applied to percpu/for-3.18-consistent-ops.  Please let me know if this
patch should be routed differently.  Note that this patch was to be
applied to percpu/for-3.17 but delayed due to build issues caused by
cpumask_var_t.

Thanks.

-- 
tejun
