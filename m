Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaJ1MsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:48:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:62409 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbaJ1MsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:48:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="407230250"
Date: Tue, 28 Oct 2014 05:48:17 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org, mingo@kernel.org, bp@suse.de,
        eranian@google.com, zheng.z.yan@intel.com, hpa@zytor.com,
        tglx@linutronix.de, josh@joshtriplett.org,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf/x86: Fix compile warnings for intel_uncore
Message-ID: <20141028124817.GE3274@tassilo.jf.intel.com>
References: <tip-7fb0f1de49fc75a0dcec22531f2d0a79fc2fb625@git.kernel.org>
 <20141028111921.GB3274@tassilo.jf.intel.com>
 <20141028124227.GR3337@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028124227.GR3337@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 01:42:28PM +0100, Peter Zijlstra wrote:
> On Tue, Oct 28, 2014 at 04:19:21AM -0700, Andi Kleen wrote:
> > > +config PERF_EVENTS_INTEL_UNCORE
> > > +	def_bool y
> > 
> > Why not give it a user name? It should be user configurable.
> 
> To avoid just that, another more or less pointless config option.

Good point. We should default to allyesconfig, because obviously everyone
needs everything.

-Andi
