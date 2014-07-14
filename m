Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbaGNTxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 15:53:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:11366 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870AbaGNTxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 15:53:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,659,1400050800"; 
   d="scan'208";a="543228403"
Date: Mon, 14 Jul 2014 12:52:59 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Stephane Eranian <eranian@gmail.com>
Subject: Re: [patch] perf: use proper dTLB-load-misses event on Ivybridge
Message-ID: <20140714195259.GD5803@tassilo.jf.intel.com>
References: <alpine.DEB.2.11.1407141528200.17214@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1407141528200.17214@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 03:33:25PM -0400, Vince Weaver wrote:
> 
> This was discussed back in February 
> 	https://lkml.org/lkml/2014/2/18/956
> But I never saw a patch come out of it.
> 
> On Ivybridge we share the Sandybridge cache event tables, but the
> dTLB-load-miss event is not compatible.  Patch it up after
> the fact to the proper DTLB_LOAD_MISSES.DEMAND_LD_MISS_CAUSES_A_WALK

There is much more wrong. I've been working on revamping the whole
tables.

-Andi
