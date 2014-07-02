Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbaGBSOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 14:14:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:29569 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756797AbaGBSOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 14:14:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,589,1400050800"; 
   d="scan'208";a="564301860"
Date: Wed, 2 Jul 2014 11:14:14 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, eranian@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf, x86: Revamp PEBS event selection
Message-ID: <20140702181414.GQ19781@tassilo.jf.intel.com>
References: <1403910612-8754-1-git-send-email-andi@firstfloor.org>
 <1403910612-8754-2-git-send-email-andi@firstfloor.org>
 <20140702122902.GC19379@twins.programming.kicks-ass.net>
 <20140702153407.GN19781@tassilo.jf.intel.com>
 <20140702154307.GM19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140702154307.GM19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But also, I think we should conditionally allow the filter bits;
> possibly with a sysfs file like I had.
> 
> Back when we had to sort that SNB cycles thing it was tedious that Linus
> could not just try things.

Hmm, the code in your patch to handle it was quite nasty.
I don't really see the situation repeating.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
