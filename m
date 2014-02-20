Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634AbaBTMEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 07:04:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59413 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308AbaBTMER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 07:04:17 -0500
Date: Thu, 20 Feb 2014 13:04:08 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Lei Wen <leiwen@marvell.com>
Cc: mingo@redhat.com, preeti.lkml@gmail.com, daniel.lezcano@linaro.org,
        viresh.kumar@linaro.org, xjian@marvell.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched: keep quiescent cpu out of idle balance loop
Message-ID: <20140220120408.GN27965@twins.programming.kicks-ass.net>
References: <20140220085017.GL6835@laptop.programming.kicks-ass.net>
 <1392887824-20138-1-git-send-email-leiwen@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392887824-20138-1-git-send-email-leiwen@marvell.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 05:17:04PM +0800, Lei Wen wrote:
> Cpu which is put into quiescent mode, would remove itself
> from kernel's sched_domain, and want others not disturb its
> task running. But current scheduler would not checking whether
> that cpu is setting in such mode, and still insist the quiescent
> cpu to response the nohz load balance.
> 
> Fix it by preventing such cpu set nohz.idle_cpus_mask in the
> first place.
> 
> Signed-off-by: Lei Wen <leiwen@marvell.com>

Thanks
