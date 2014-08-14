Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbaHNO64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:58:56 -0400
Received: from mga01.intel.com ([192.55.52.88]:40738 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625AbaHNO6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:58:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="372400277"
Date: Thu, 14 Aug 2014 07:58:54 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, eranian@google.com
Subject: Re: [PATCH 3/5] perf, x86: Add Broadwell core support
Message-ID: <20140814145854.GQ5803@tassilo.jf.intel.com>
References: <1407979069-7121-1-git-send-email-andi@firstfloor.org>
 <1407979069-7121-4-git-send-email-andi@firstfloor.org>
 <20140814070722.GD16043@twins.programming.kicks-ass.net>
 <20140814073210.GP3588@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140814073210.GP3588@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 09:32:10AM +0200, Peter Zijlstra wrote:
> On Thu, Aug 14, 2014 at 09:07:22AM +0200, Peter Zijlstra wrote:
> > On Wed, Aug 13, 2014 at 06:17:47PM -0700, Andi Kleen wrote:
> > 
> > > v2: Remove unnamed model numbers.
> > 
> > > +	case 61: /* Broadwell Client */
> > 
> > Seriously? So 71 and 79 are fine as a number but you cannot name them?
> 
> would something like:
> 
> 	case 71: /* 14nm Broadwell TBA */
> 
> work? Where you then will update the description at the appropriate
> time?

There won't be a single description, it will turn into all kinds 
of products. The names I used are the ones we use.

Really, Peter, it's futile to try to reproduce http://ark.intel.com
in perf comments. If you need information on specific Intel
products please look it up there.
 
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
