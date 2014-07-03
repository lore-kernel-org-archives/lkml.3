Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbaGDIC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 04:02:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:62443 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753979AbaGDICR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 04:02:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,599,1400050800"; 
   d="scan'208";a="538721013"
Date: Fri, 4 Jul 2014 07:50:45 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "Dietmar.Eggemann@arm.com" <Dietmar.Eggemann@arm.com>,
        "pjt@google.com" <pjt@google.com>
Subject: Re: [RFCv2 PATCH 08/23] sched: Aggregate unweighted load contributed
 by task entities on parenting cfs_rq
Message-ID: <20140703235045.GB4881@intel.com>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
 <1404404770-323-9-git-send-email-morten.rasmussen@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404404770-323-9-git-send-email-morten.rasmussen@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 12:25:55AM +0800, Morten Rasmussen wrote:
> From: Dietmar Eggemann <dietmar.eggemann@arm.com>
> 
> Energy aware scheduling relies on cpu utilization and to be able to
> maintain it, we need a per run queue signal of the sum of the
> unweighted, i.e. not scaled with task priority, load contribution of
> runnable task entries.
> 
> The unweighted runnable load on a run queue is maintained alongside the
> existing (weighted) runnable load.
> 
> This patch is the unweighted counterpart of "sched: Aggregate load
> contributed by task entities on parenting cfs_rq" (commit id
> 2dac754e10a5).
> 
Hi Dietmar and Morten,

You may or may not have noticed my patch the other day:

sched: Rewrite per entity runnable load average tracking

With this new load average tracking, unweighted load average will be very much
simplifed to do.

Thanks,
Yuyang
