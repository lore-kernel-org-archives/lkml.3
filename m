Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbaIKLyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:54:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:55633 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbaIKLyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:54:15 -0400
Date: Thu, 11 Sep 2014 13:54:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        riel@redhat.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com
Subject: Re: [PATCH v5 08/12] sched: move cfs task on a CPU with higher
 capacity
Message-ID: <20140911115411.GX3190@worktop.ger.corp.intel.com>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-9-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409051215-16788-9-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 01:06:51PM +0200, Vincent Guittot wrote:
> +		if ((capacity_orig_of(src_cpu) * 100) > (capacity_of(src_cpu) *
> +				sd->imbalance_pct))

Note that capacity_orig_of() is introduced a lot later on in the series.
Patch 10 iirc, so this will not actually compile.
