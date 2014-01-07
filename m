Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104AbaAGJvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 04:51:06 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53261 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930AbaAGJvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 04:51:02 -0500
Date: Tue, 7 Jan 2014 10:50:39 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, pjt@google.com, Morten.Rasmussen@arm.com,
        cmetcalf@tilera.com, tony.luck@intel.com, alex.shi@linaro.org,
        linaro-kernel@lists.linaro.org, rjw@sisk.pl,
        paulmck@linux.vnet.ibm.com, corbet@lwn.net, tglx@linutronix.de,
        len.brown@intel.com, arjan@linux.intel.com, amit.kucheria@linaro.org,
        james.hogan@imgtec.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, Dietmar.Eggemann@arm.com
Subject: Re: [RFC] sched: CPU topology try
Message-ID: <20140107095039.GA2480@laptop.programming.kicks-ass.net>
References: <20131105222752.GD16117@laptop.programming.kicks-ass.net>
 <1387372431-2644-1-git-send-email-vincent.guittot@linaro.org>
 <52CBCB85.8050607@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CBCB85.8050607@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 03:10:21PM +0530, Preeti U Murthy wrote:
> What if we want to add arch specific flags to the NUMA domain? Currently
> with Peter's patch:https://lkml.org/lkml/2013/11/5/239 and this patch,
> the arch can modify the sd flags of the topology levels till just before
> the NUMA domain. In sd_init_numa(), the flags for the NUMA domain get
> initialized. We need to perhaps call into arch here to probe for
> additional flags?

What are you thinking of? I was hoping all NUMA details were captured in
the distance table.

Its far easier to talk of specifics in this case.
