Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758203AbaCSIrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 04:47:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54883 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060AbaCSIrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 04:47:35 -0400
Date: Wed, 19 Mar 2014 09:47:10 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/4] hrtimer: export __hrtimer_start_range_ns
Message-ID: <20140319084710.GD27632@laptop.programming.kicks-ass.net>
References: <1395133004-23205-1-git-send-email-zheng.z.yan@intel.com>
 <1395133004-23205-2-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395133004-23205-2-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 04:56:42PM +0800, Yan, Zheng wrote:
> export __hrtimer_start_range_ns() to allow building perf Intel uncore
> driver as module

Bah; you didn't cc the hrtimer maintainer.

Thomas, ack on this?

> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> ---
>  kernel/hrtimer.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 0909436..650bf38 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -1030,6 +1030,7 @@ int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
>  
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(__hrtimer_start_range_ns);
>  
>  /**
>   * hrtimer_start_range_ns - (re)start an hrtimer on the current CPU
> -- 
> 1.8.5.3
> 
