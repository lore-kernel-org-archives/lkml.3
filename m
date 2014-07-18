Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422719AbaGRXbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 19:31:32 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:64780 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030293AbaGRXbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 19:31:31 -0400
Date: Fri, 18 Jul 2014 19:31:27 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 19/31] MIPS: Replace __get_cpu_var uses in FPU emulator.
Message-ID: <20140718233127.GY5739@htj.dyndns.org>
References: <20140620193115.547427118@linux.com>
 <20140620193127.123705312@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620193127.123705312@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 02:31:34PM -0500, Christoph Lameter wrote:
> 
> From: David Daney <david.daney@cavium.com>
> 
> The use of __this_cpu_inc() requires a fundamental integer type, so
> change the type of all the counters to unsigned long, which is the
> same width they were before, but not wrapped in local_t.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Applied to wq/for-3.17-consistent-ops.  If this patch should be routed
differently, please holler.

Thanks.

-- 
tejun
