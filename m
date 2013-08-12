Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab3HLPaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 11:30:09 -0400
Received: from mga03.intel.com ([143.182.124.21]:46728 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756800Ab3HLPaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 11:30:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,862,1367996400"; 
   d="scan'208";a="280899474"
Date: Mon, 12 Aug 2013 08:29:57 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, linux-kernel@vger.kernel.org,
        eranian@google.com
Subject: Re: [PATCH 3/3] perf, uncore: enable ev_sel_ext bit for PCU.
Message-ID: <20130812152957.GF23412@tassilo.jf.intel.com>
References: <1375856245-10717-1-git-send-email-zheng.z.yan@intel.com>
 <1375856245-10717-3-git-send-email-zheng.z.yan@intel.com>
 <20130812151632.GM27162@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130812151632.GM27162@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 05:16:32PM +0200, Peter Zijlstra wrote:
> On Wed, Aug 07, 2013 at 02:17:25PM +0800, Yan, Zheng wrote:
> > From: "Yan, Zheng" <zheng.z.yan@intel.com>
> > 
> > PCU uncore event control register has a undocumented ev_sel_ext bit.
> > The bit is needed by Andi's pmu-tools.
> 
> Please provide documentation. Andi needing it isn't a good changelog (or
> even reason).

The bit is in the uncore guide, just not in the register documentation,
but in the event descriptions.

e.g. the PCU part calls it "Extra Select Bit"

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
