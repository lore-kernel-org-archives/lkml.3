Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbaHZSKX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 14:10:23 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:50424 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbaHZSKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 14:10:20 -0400
Date: Tue, 26 Aug 2014 14:10:15 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, nicolas.pitre@linaro.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 16/35] [PATCH 16/36] irqchips: Replace __this_cpu_ptr uses
Message-ID: <20140826181015.GY31659@mtj.dyndns.org>
References: <20140817173023.439660246@linux.com>
 <20140817173035.423458762@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140817173035.423458762@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2014 at 12:30:39PM -0500, Christoph Lameter wrote:
> [ARM specific]
> 
> These are generally replaced with raw_cpu_ptr. However, in
> gic_get_percpu_base() we immediately dereference the pointer. This is
> equivalent to a raw_cpu_read. So use that operation there.
> 
> Cc: nicolas.pitre@linaro.org
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Christoph Lameter <cl@linux.com>

(Please disregard the ones I posted for v1 of the patch series)

Applied to percpu/for-3.18-consistent-ops.  Please let me know if this
patch should be routed differently.  Note that this patch was to be
applied to percpu/for-3.17 but delayed due to build issues caused by
cpumask_var_t.

Thanks.

-- 
tejun
