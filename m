Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977AbaHZSQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 14:16:03 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:56924 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbaHZSQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 14:16:00 -0400
Date: Tue, 26 Aug 2014 14:15:56 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: Re: [PATCH 30/35] [PATCH 30/36] avr32: Replace __get_cpu_var with
 __this_cpu_write
Message-ID: <20140826181556.GM31659@mtj.dyndns.org>
References: <20140817173023.439660246@linux.com>
 <20140817173037.592030835@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140817173037.592030835@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2014 at 12:30:53PM -0500, Christoph Lameter wrote:
> Replace the single use of __get_cpu_var in avr32 with
> __this_cpu_write.
> 
> Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>
> Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
> Signed-off-by: Christoph Lameter <cl@linux.com>

(Please disregard the ones I posted for v1 of the patch series)

Applied to percpu/for-3.18-consistent-ops.  Please let me know if this
patch should be routed differently.  Note that this patch was to be
applied to percpu/for-3.17 but delayed due to build issues caused by
cpumask_var_t.

Thanks.

-- 
tejun
