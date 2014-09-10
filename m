Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919AbaIJODe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:03:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:38808 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbaIJODd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:03:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,499,1406617200"; 
   d="scan'208";a="476612687"
Date: Wed, 10 Sep 2014 07:02:58 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, eranian@google.com, tglx@linutronix.de
Subject: Re: [PATCH 2/2] perf, x86: Use INTEL_FLAGS_UEVENT_CONSTRAINT for
 PRECDIST
Message-ID: <20140910140258.GI5387@tassilo.jf.intel.com>
References: <1410310148-26260-1-git-send-email-andi@firstfloor.org>
 <1410310148-26260-2-git-send-email-andi@firstfloor.org>
 <20140910075926.GM6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910075926.GM6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 09:59:26AM +0200, Peter Zijlstra wrote:
> On Tue, Sep 09, 2014 at 05:49:08PM -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > The earlier commit 86a04461a made near all PEBS on
> > Sandy/IvyBridge/Haswell to reject non zero flags.
> 
> What's magic about nehalem and westmere?

I wasn't able to confirm their behavior explicitly, so I felt
it best to leave them alone.

But in principle adding the _FLAGS changes there too would
make sense too.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
