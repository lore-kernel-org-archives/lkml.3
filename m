Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932804AbaGRX3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 19:29:10 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:52669 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406AbaGRX3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 19:29:06 -0400
Date: Fri, 18 Jul 2014 19:29:03 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        James Hogan <james.hogan@imgtec.com>
Subject: Re: [PATCH 08/31] drivers/clocksource: Replace __get_cpu_var used
 for address calculation
Message-ID: <20140718232903.GO5739@htj.dyndns.org>
References: <20140620193115.547427118@linux.com>
 <20140620193125.796020467@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620193125.796020467@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 02:31:23PM -0500, Christoph Lameter wrote:
> Replace __get_cpu_var used for address calculation with this_cpu_ptr.
> 
> Acked-by: James Hogan <james.hogan@imgtec.com>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Applied to wq/for-3.17-consistent-ops.  If this patch should be routed
differently, please holler.

Thanks.

-- 
tejun
