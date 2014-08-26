Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbaHZSIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 14:08:31 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:53780 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738AbaHZSI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 14:08:29 -0400
Date: Tue, 26 Aug 2014 14:08:24 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        James Hogan <james.hogan@imgtec.com>
Subject: Re: [PATCH 09/35] [PATCH 09/36] drivers/clocksource: Replace
 __get_cpu_var used for address calculation
Message-ID: <20140826180824.GR31659@mtj.dyndns.org>
References: <20140817173023.439660246@linux.com>
 <20140817173034.330628593@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140817173034.330628593@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2014 at 12:30:32PM -0500, Christoph Lameter wrote:
> Replace __get_cpu_var used for address calculation with this_cpu_ptr.
> 
> Acked-by: James Hogan <james.hogan@imgtec.com>
> Signed-off-by: Christoph Lameter <cl@linux.com>

(Please disregard the ones I posted for v1 of the patch series)

Applied to percpu/for-3.18-consistent-ops.  Please let me know if this
patch should be routed differently.  Note that this patch was to be
applied to percpu/for-3.17 but delayed due to build issues caused by
cpumask_var_t.

Thanks.

-- 
tejun
