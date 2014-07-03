Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaGDHWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:22:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:59609 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbaGDHWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:22:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,599,1400050800"; 
   d="scan'208";a="538707984"
Date: Fri, 4 Jul 2014 07:19:50 +0800
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
Subject: Re: [RFCv2 PATCH 00/23] sched: Energy cost model for energy-aware
 scheduling
Message-ID: <20140703231950.GA4881@intel.com>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Morten,

On Fri, Jul 04, 2014 at 12:25:47AM +0800, Morten Rasmussen wrote:
> * Note that these energy savings are _not_ representative of what can be
> achieved on a true SMP platform where all cpus are equally 
> energy-efficient. There should be benefit for SMP platforms as well, 
> however, it will be smaller.
> 
> The energy model led to consolidation of the short tasks on the A7
> cluster (more energy-efficient), while sysbench made use of all cpus as
> the A7s didn't have sufficient compute capacity to handle the five
> tasks.

Looks like this patchset is mainly for big.LITTLE? And can the patchset
actually replace Global Task Scheduling?

Thanks,
Yuyang
