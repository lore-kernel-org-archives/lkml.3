Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbaGHI0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:26:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:21726 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695AbaGHI0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:26:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,624,1400050800"; 
   d="scan'208";a="558722879"
Date: Tue, 8 Jul 2014 08:23:43 +0800
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
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "pjt@google.com" <pjt@google.com>
Subject: Re: [RFCv2 PATCH 00/23] sched: Energy cost model for energy-aware
 scheduling
Message-ID: <20140708002343.GC25653@intel.com>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
 <20140703231950.GA4881@intel.com>
 <20140704110612.GA6120@e103034-lin>
 <20140706190523.GA12113@intel.com>
 <20140707141627.GB4485@e103687>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140707141627.GB4485@e103687>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Morten,

On Mon, Jul 07, 2014 at 03:16:27PM +0100, Morten Rasmussen wrote:

> Could you elaborate on what you mean by 'a general statement'?

The general statement is: higher freq, more cap, and more power. More specific
numbers are not needed, as they are just instances of this general statement.

> cpu_power doesn't tell you anything about energy-efficiency. There is no
> link with frequency scaling.

In general, more cpu_power, more freq, less energy-efficiency, as you said sometime ago.

> No representation of power domains.

Represented by CPU topology?

Thanks,
Yuyang
