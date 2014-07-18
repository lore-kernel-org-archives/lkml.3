Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965305AbaGRXaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 19:30:00 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:41801 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964944AbaGRX36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 19:29:58 -0400
Date: Fri, 18 Jul 2014 19:29:55 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 12/31] md: Replace __this_cpu_ptr with raw_cpu_ptr
Message-ID: <20140718232955.GS5739@htj.dyndns.org>
References: <20140620193115.547427118@linux.com>
 <20140620193126.279406340@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620193126.279406340@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 02:31:27PM -0500, Christoph Lameter wrote:
> __this_cpu_ptr is being phased out.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>

Applied to wq/for-3.17-consistent-ops.  If this patch should be routed
differently, please holler.

Thanks.

-- 
tejun
