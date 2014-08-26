Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbaHZSBZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 14:01:25 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:54493 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbaHZSBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 14:01:23 -0400
Date: Tue, 26 Aug 2014 14:01:18 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Bryan Wu <cooloney@gmail.com>
Subject: Re: [PATCH 08/41] drivers/leds: Replace __get_cpu_var use through
 this_cpu_ptr
Message-ID: <20140826180118.GG31659@mtj.dyndns.org>
References: <20131203233232.928771708@linux.com>
 <20131203233249.095099597@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203233249.095099597@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 05:32:40PM -0600, Christoph Lameter wrote:
> Use this_cpu_ptr for the address calculation instead of __get_cpu_var.
> 
> Acked-by: Bryan Wu <cooloney@gmail.com>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Applied to percpu/for-3.18-consistent-ops.  Please let me know if this
patch should be routed differently.  Note that this patch was to be
applied to percpu/for-3.17 but delayed due to build issues caused by
cpumask_var_t.

Thanks.

-- 
tejun
