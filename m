Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953AbaHZSNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 14:13:24 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:41084 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbaHZSNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 14:13:23 -0400
Date: Tue, 26 Aug 2014 14:13:18 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 22/35] [PATCH 22/36] s390: Replace __get_cpu_var uses
Message-ID: <20140826181318.GF31659@mtj.dyndns.org>
References: <20140817173023.439660246@linux.com>
 <20140817173036.329086654@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140817173036.329086654@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2014 at 12:30:45PM -0500, Christoph Lameter wrote:
> __get_cpu_var() is used for multiple purposes in the kernel source. One of
> them is address calculation via the form &__get_cpu_var(x).  This calculates
> the address for the instance of the percpu variable of the current processor
> based on an offset.
> 
> Other use cases are for storing and retrieving data from the current
> processors percpu area.  __get_cpu_var() can be used as an lvalue when
> writing data or on the right side of an assignment.
...
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> CC: linux390@de.ibm.com
> Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> Signed-off-by: Christoph Lameter <cl@linux.com>

(Please disregard the ones I posted for v1 of the patch series)

Applied to percpu/for-3.18-consistent-ops.  Please let me know if this
patch should be routed differently.  Note that this patch was to be
applied to percpu/for-3.17 but delayed due to build issues caused by
cpumask_var_t.

Thanks.

-- 
tejun
