Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbaJ1Mmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 08:42:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:58263 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbaJ1Mmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 08:42:37 -0400
Date: Tue, 28 Oct 2014 13:42:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: akpm@linux-foundation.org, mingo@kernel.org, bp@suse.de,
        eranian@google.com, zheng.z.yan@intel.com, hpa@zytor.com,
        tglx@linutronix.de, josh@joshtriplett.org,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf/x86: Fix compile warnings for intel_uncore
Message-ID: <20141028124227.GR3337@twins.programming.kicks-ass.net>
References: <tip-7fb0f1de49fc75a0dcec22531f2d0a79fc2fb625@git.kernel.org>
 <20141028111921.GB3274@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141028111921.GB3274@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 04:19:21AM -0700, Andi Kleen wrote:
> > +config PERF_EVENTS_INTEL_UNCORE
> > +	def_bool y
> 
> Why not give it a user name? It should be user configurable.

To avoid just that, another more or less pointless config option.

> > +	depends on PERF_EVENTS && SUP_SUP_INTEL && PCI
> 
> SUP_SUP_INTEL looks wrong. Should be CPU_SUP_INTEL
> 
> I suspect you disabled it completely.

Indeed, typo there.
