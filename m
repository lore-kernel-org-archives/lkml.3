Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaDOHxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 03:53:43 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53990 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbaDOHxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 03:53:40 -0400
Date: Tue, 15 Apr 2014 09:53:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v4 0/5] rework sched_domain topology description
Message-ID: <20140415075310.GI11182@twins.programming.kicks-ass.net>
References: <1397209481-28542-1-git-send-email-vincent.guittot@linaro.org>
 <534937F0.3020702@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534937F0.3020702@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 12, 2014 at 01:56:16PM +0100, Dietmar Eggemann wrote:
> On 11/04/14 10:44, Vincent Guittot wrote:
> >This patchset was previously part of the larger tasks packing patchset [1].
> >I have splitted the latter in 3 different patchsets (at least) to make the
> >thing easier.
> >-configuration of sched_domain topology (this patchset)
> >-update and consolidation of cpu_power
> >-tasks packing algorithm
> >
> >Based on Peter Z's proposal [2][3], this patchset modifies the way to configure
> >the sched_domain level in order to let architectures to add specific level like
> >the current BOOK level or the proposed power gating level for ARM architecture.
> >
> >[1] https://lkml.org/lkml/2013/10/18/121
> >[2] https://lkml.org/lkml/2013/11/5/239
> >[3] https://lkml.org/lkml/2013/11/5/449
> 
> Hi Vincent,
> 
> given the discussion we had for v1-v3 and a short boot test of v4:
> 
> For patch 1/5, 4/5, 5/5 on ARM TC2 (heterogeneous dual socket w/o SMT
> machine):
> 
> Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>

Thanks guys!
