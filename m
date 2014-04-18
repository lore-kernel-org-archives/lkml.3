Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbaDRLjh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 07:39:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59226 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaDRLjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 07:39:32 -0400
Date: Fri, 18 Apr 2014 13:39:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, dietmar.eggemann@arm.com,
        preeti@linux.vnet.ibm.com, linaro-kernel@lists.linaro.org,
        tony.luck@intel.com, fenghua.yu@intel.com, schwidefsky@de.ibm.com,
        cmetcalf@tilera.com, benh@kernel.crashing.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] fix: sched: rework of sched_domain topology definition
Message-ID: <20140418113904.GW11182@twins.programming.kicks-ass.net>
References: <20140418105601.GU11182@twins.programming.kicks-ass.net>
 <1397820846-32603-1-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397820846-32603-1-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 01:34:06PM +0200, Vincent Guittot wrote:
> fix missing change from int to pointer function for numa flags
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>

Thanks, folded it into the original patch.
