Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbaLOQ71 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:59:27 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:50054 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbaLOQ7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:59:23 -0500
Date: Mon, 15 Dec 2014 17:59:08 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: jun.zhang@intel.com
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Changcheng Liu <changcheng.liu@intel.com>,
        Hillf Danton <hillf.zj@alibaba-inc.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH] sched/fair: fix find_idlest_cpu return -1
Message-ID: <20141215165908.GC29390@twins.programming.kicks-ass.net>
References: <1417759082-28385-1-git-send-email-jun.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417759082-28385-1-git-send-email-jun.zhang@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2014 at 01:58:01PM +0800, jun.zhang@intel.com wrote:
> From: zhang jun <jun.zhang@intel.com>
> 
> find_idlest_cpu return -1 is not reasonable, set default value to this_cpu.

This fails to explain why.

> Signed-off-by: zhang jun <jun.zhang@intel.com>
> Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> Signed-off-by: Changcheng Liu <changcheng.liu@intel.com>

This is an invalid SoB chain.

> Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Cc: <stable@vger.kernel.org> # 3.14.25
