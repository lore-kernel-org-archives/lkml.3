Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaGJLYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:24:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:35569 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbaGJLYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:24:43 -0400
Date: Thu, 10 Jul 2014 13:24:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com
Subject: Re: [PATCH v3 08/12] sched: move cfs task on a CPU with higher
 capacity
Message-ID: <20140710112441.GZ3935@laptop>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-9-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404144343-18720-9-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 06:05:39PM +0200, Vincent Guittot wrote:
> +		if ((sd->flags & SD_SHARE_PKG_RESOURCES)
> +		 && ((capacity_orig_of(src_cpu) * 100) > (capacity_of(src_cpu) *
> +							sd->imbalance_pct)))


> +		if ((rq->cfs.h_nr_running >= 1)
> +		 && ((rq->cpu_capacity * sd->imbalance_pct) <
> +					(rq->cpu_capacity_orig * 100))) {

That's just weird indentation and operators should be at the end not at
the beginning of a line-break.
