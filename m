Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760288AbaGRX1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 19:27:53 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:41046 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423AbaGRX1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 19:27:51 -0400
Date: Fri, 18 Jul 2014 19:27:48 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 03/31] scheduler: Replace __get_cpu_var with this_cpu_ptr
Message-ID: <20140718232748.GJ5739@htj.dyndns.org>
References: <20140620193115.547427118@linux.com>
 <20140620193125.209414560@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620193125.209414560@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 02:31:18PM -0500, Christoph Lameter wrote:
> Convert all uses of __get_cpu_var for address calculation to use
> this_cpu_ptr instead.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Acked-by: Ingo Molnar <mingo@kernel.org>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Applied to wq/for-3.17-consistent-ops.  If this patch should be routed
differently, please holler.

Thanks.

-- 
tejun
