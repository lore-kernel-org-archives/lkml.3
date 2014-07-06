Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaGGDIY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 23:08:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:39485 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbaGGDIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 23:08:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,615,1400050800"; 
   d="scan'208";a="539517080"
Date: Mon, 7 Jul 2014 03:05:23 +0800
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
Message-ID: <20140706190523.GA12113@intel.com>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
 <20140703231950.GA4881@intel.com>
 <20140704110612.GA6120@e103034-lin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140704110612.GA6120@e103034-lin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Morten,

Thanks, got it. Then another question,

On Fri, Jul 04, 2014 at 12:06:13PM +0100, Morten Rasmussen wrote:
> The patch set essentially puts tasks where it is most energy-efficient
> guided by the platform energy model. That should benefit any platform,
> SMP and big.LITTLE. That is at least the goal.
> 

I understand energy_diff_* functions are based on the energy model (though I
have not dived into the detail of how you change load balancing based on
energy_diff_*).

Speaking of the engergy model, I am not sure why elaborate "imprecise" energy
numbers do a better job than only a general statement: higher freq, more cap,
and more power.

Even for big.LITTLE systems, big and little CPUs also follow that statement
respectively. Then it is just a matter of where to place tasks between them.
Under such, the energy model might be useful, but still probably cpu_power_orig
(from Vincent) might be enough.

Thanks,
Yuyang
