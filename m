Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbaIKLSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 07:18:08 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43750 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbaIKLSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 07:18:05 -0400
Date: Thu, 11 Sep 2014 13:17:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, preeti@linux.vnet.ibm.com,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        riel@redhat.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com
Subject: Re: [PATCH v5 09/11] sched: add usage_load_avg
Message-ID: <20140911111754.GW3190@worktop.ger.corp.intel.com>
References: <1409051215-16788-10-git-send-email-vincent.guittot@linaro.org>
 <1409816079-10131-1-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409816079-10131-1-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 09:34:39AM +0200, Vincent Guittot wrote:
> The update of update_rq_runnable_avg interface is missing for
> CONFIG_FAIR_GROUP_SCHED in the original patch
> "[PATCH v5 09/12] sched: add usage_load_avg"
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
> 
> Hi Peter,
> 
> Do you prefer that I sent a new version of 
> "[PATCH v5 09/12] sched: add usage_load_avg" patch with the fix or this fix is
> enough ?

This is fine, I hand edited the previous patch.
