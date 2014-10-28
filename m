Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955AbaJ1LT0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:19:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:25664 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753910AbaJ1LTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:19:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,802,1406617200"; 
   d="scan'208";a="622002705"
Date: Tue, 28 Oct 2014 04:19:21 -0700
From: Andi Kleen <ak@linux.intel.com>
To: akpm@linux-foundation.org, peterz@infradead.org, mingo@kernel.org,
        bp@suse.de, eranian@google.com, zheng.z.yan@intel.com, hpa@zytor.com,
        tglx@linutronix.de, josh@joshtriplett.org,
        linux-kernel@vger.kernel.org
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf/x86: Fix compile warnings for intel_uncore
Message-ID: <20141028111921.GB3274@tassilo.jf.intel.com>
References: <tip-7fb0f1de49fc75a0dcec22531f2d0a79fc2fb625@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-7fb0f1de49fc75a0dcec22531f2d0a79fc2fb625@git.kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +config PERF_EVENTS_INTEL_UNCORE
> +	def_bool y

Why not give it a user name? It should be user configurable.

> +	depends on PERF_EVENTS && SUP_SUP_INTEL && PCI

SUP_SUP_INTEL looks wrong. Should be CPU_SUP_INTEL

I suspect you disabled it completely.

-Andi
