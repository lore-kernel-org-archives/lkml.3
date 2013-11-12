Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab3KLKe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 05:34:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55232 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178Ab3KLKew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 05:34:52 -0500
Date: Tue, 12 Nov 2013 11:34:40 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, pjt@google.com,
        Morten.Rasmussen@arm.com, cmetcalf@tilera.com, tony.luck@intel.com,
        alex.shi@intel.com, preeti@linux.vnet.ibm.com,
        linaro-kernel@lists.linaro.org, rjw@sisk.pl,
        paulmck@linux.vnet.ibm.com, corbet@lwn.net, tglx@linutronix.de,
        len.brown@intel.com, arjan@linux.intel.com, amit.kucheria@linaro.org,
        l.majewski@samsung.com
Subject: Re: [RFC][PATCH v5 06/14] sched: create a new field with available
 capacity
Message-ID: <20131112103440.GF4971@laptop.programming.kicks-ass.net>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
 <1382097147-30088-6-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382097147-30088-6-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 18, 2013 at 01:52:19PM +0200, Vincent Guittot wrote:
> This new field power_available reflects the available capacity of a CPU
> unlike the cpu_power which reflects the current capacity.

> -	sdg->sgp->power_orig = sdg->sgp->power = power;
> +	sdg->sgp->power_orig = sdg->sgp->power_available = available;
> +	sdg->sgp->power = power;

This patch leaves me confused as to power_available vs power_orig and
the Changelog doesn't really clarify anything much at all.
