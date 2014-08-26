Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaHZSAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 14:00:20 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:59262 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbaHZSAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 14:00:16 -0400
Date: Tue, 26 Aug 2014 14:00:12 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 03/41] percpu: Replace __get_cpu_var with this_cpu_ptr
Message-ID: <20140826180012.GC31659@mtj.dyndns.org>
References: <20131203233232.928771708@linux.com>
 <20131203233246.455803820@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203233246.455803820@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 05:32:35PM -0600, Christoph Lameter wrote:
> One case of using __get_cpu_var in the get_cpu_var macro
> for address calculation.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Applied to percpu/for-3.18-consistent-ops.  Please let me know if this
patch should be routed differently.  Note that this patch was to be
applied to percpu/for-3.17 but delayed due to build issues caused by
cpumask_var_t.

Thanks.

-- 
tejun
