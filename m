Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760462AbaGRX2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 19:28:13 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:62875 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577AbaGRX2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 19:28:12 -0400
Date: Fri, 18 Jul 2014 19:28:08 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 04/31] block: Replace __this_cpu_ptr with raw_cpu_ptr
Message-ID: <20140718232808.GK5739@htj.dyndns.org>
References: <20140620193115.547427118@linux.com>
 <20140620193125.325765953@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140620193125.325765953@linux.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 20, 2014 at 02:31:19PM -0500, Christoph Lameter wrote:
> __this_cpu_ptr is being phased out use raw_cpu_ptr instead which was
> introduced in 3.15-rc1.
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Christoph Lameter <cl@linux.com>

Applied to wq/for-3.17-consistent-ops.  If this patch should be routed
differently, please holler.

Thanks.

-- 
tejun
