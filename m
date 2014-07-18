Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319AbaGRX2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 19:28:55 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:37235 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760604AbaGRX2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 19:28:53 -0400
Date: Fri, 18 Jul 2014 19:28:50 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Robert Richter <rric@kernel.org>,
        oprofile-list@lists.sf.net
Subject: Re: [PATCH 07/31] drivers/oprofile: Replace __get_cpu_var uses for
 address calculation
Message-ID: <20140718232850.GN5739@htj.dyndns.org>
References: <20140620193115.547427118@linux.com>
 <20140620193125.688151423@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620193125.688151423@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 02:31:22PM -0500, Christoph Lameter wrote:
> Replace the uses of __get_cpu_var for address calculation with this_cpu_ptr.
> 
> Cc: Robert Richter <rric@kernel.org>
> Cc: oprofile-list@lists.sf.net
> Signed-off-by: Christoph Lameter <cl@linux.com>

Applied to wq/for-3.17-consistent-ops.  If this patch should be routed
differently, please holler.

Thanks.

-- 
tejun
