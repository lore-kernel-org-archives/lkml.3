Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaIXOeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:34:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:8876 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbaIXOea (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:34:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,589,1406617200"; 
   d="scan'208";a="604682522"
Date: Wed, 24 Sep 2014 07:34:22 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, eranian@google.com
Subject: Re: [PATCH] perf, x86: Disallow flags for most
 Core2/Atom/Nehalem/Westmere events
Message-ID: <20140924143422.GI28253@tassilo.jf.intel.com>
References: <1411509264-18135-1-git-send-email-andi@firstfloor.org>
 <20140924074753.GR16043@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924074753.GR16043@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 09:47:53AM +0200, Peter Zijlstra wrote:
> On Tue, Sep 23, 2014 at 02:54:24PM -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Disallow setting inv/cmask/etc. flags for all PEBS events
> > on these CPUs, except for the UOPS_RETIRED.* events on Nehalem/Westmere,
> > which are needed for cycles:p. This avoids an undefined situation
> > strongly discouraged by the Intle SDM. The PLD_* events were already
> > covered. This follows the earlier changes for Sandy Bridge and alter.
> > 
> > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> From the compile before sending dept:

Sorry, I only sent one patch, instead of all three. Will resend.

-Andi
