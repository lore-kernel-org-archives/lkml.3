Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbaFHH5E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 03:57:04 -0400
Received: from mga03.intel.com ([143.182.124.21]:27253 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbaFHH5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 03:57:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,997,1392192000"; 
   d="scan'208";a="442763538"
Date: Sun, 8 Jun 2014 07:53:07 +0800
From: Yuyang Du <yuyang.du@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>, len.brown@intel.com,
        jacob.jun.pan@linux.intel.com
Subject: Re: [RFC PATCH 06/16] arm: topology: Define TC2 sched energy and
 provide it to scheduler
Message-ID: <20140607235307.GD22261@intel.com>
References: <20140604160230.GS29593@e103034-lin>
 <20140604172712.GJ13930@laptop.programming.kicks-ass.net>
 <2484761.vkWavnsDx3@vostro.rjw.lan>
 <20140605065205.GA3213@twins.programming.kicks-ass.net>
 <539086B3.2010804@gmail.com>
 <20140605202930.GA15484@intel.com>
 <20140606080543.GR6758@twins.programming.kicks-ass.net>
 <20140606003520.GB22261@intel.com>
 <20140606105036.GQ3213@twins.programming.kicks-ass.net>
 <20140606121305.GA8571@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140606121305.GA8571@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 02:13:05PM +0200, Ingo Molnar wrote:
> 
> Leakage current typically gets higher with higher frequencies, but 
> it's also highly process dependent AFAIK.
> 

In general, you can assume leakage power ~ V^2.

> If switching power dissipation is the main factor in power use, then 
> we can essentially assume that P ~ V^2, at the same frequency - and 
> scales linearly with frequency - but real work performed also scales 
> semi-linearly with frequency for many workloads, so that's an 
> invariant for everything except highly memory bound workloads.
> 

Agreed. Strictly, Energy ~ V^2.
