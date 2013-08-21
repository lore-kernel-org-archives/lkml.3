Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab3HUCJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 22:09:24 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:62965 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab3HUCJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 22:09:23 -0400
X-AuditID: 9c93017d-b7cdfae0000026c0-2e-521421500c94
Date: Wed, 21 Aug 2013 11:09:24 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH 00/10] Various load-balance cleanups/optimizations -v2
Message-ID: <20130821020924.GB6142@lge.com>
References: <20130819160058.539049611@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130819160058.539049611@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 06:00:58PM +0200, Peter Zijlstra wrote:
> 
> After poking at them a little more I feel somewhat more confident.
> 
> I found one more bug, but this one was my own fault, we should also clear
> sds->busiest_stat.avg_load because update_sd_pick_busiest() reads that before
> we set it.
> 
> Moved the memset optimization and the fix for that into a separate patch.
> 
> Other than that, there's a sched_domain degenerate fix; and a new way to detect
> group_imb (which relies on the sched_domain fix).

I'm fine to my patches with your changes.

Thanks!
