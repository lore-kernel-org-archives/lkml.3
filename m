Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030621AbaGRXaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 19:30:46 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:63804 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030293AbaGRXam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 19:30:42 -0400
Date: Fri, 18 Jul 2014 19:30:39 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, nicolas.pitre@linaro.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 15/31] irqchips: Replace __this_cpu_ptr uses
Message-ID: <20140718233039.GV5739@htj.dyndns.org>
References: <20140620193115.547427118@linux.com>
 <20140620193126.630055484@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620193126.630055484@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 02:31:30PM -0500, Christoph Lameter wrote:
> [ARM specific]
> 
> These are generally replaced with raw_cpu_ptr. However, in
> gic_get_percpu_base() we immediately dereference the pointer. This is
> equivalent to a raw_cpu_read. So use that operation there.
> 
> Cc: nicolas.pitre@linaro.org
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Applied to wq/for-3.17-consistent-ops.  If this patch should be routed
differently, please holler.

Thanks.

-- 
tejun
