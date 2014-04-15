Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbaDOOL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 10:11:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:45149 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbaDOOL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 10:11:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,864,1389772800"; 
   d="scan'208";a="513544273"
Date: Tue, 15 Apr 2014 07:11:43 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org,
        kpreempt-tech@lists.sourceforge.net
Subject: Re: Soft lockup regression since kernel 3.13
Message-ID: <20140415141143.GA10589@psi-dev26.jf.intel.com>
References: <20140402232948.GA4725@psi-dev26.jf.intel.com>
 <20140408084935.GM11096@twins.programming.kicks-ass.net>
 <20140408201304.GC5332@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140408201304.GC5332@psi-dev26.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 01:13:04PM -0700, David Cohen wrote:
> On Tue, Apr 08, 2014 at 10:49:35AM +0200, Peter Zijlstra wrote:
> > On Wed, Apr 02, 2014 at 04:29:48PM -0700, David Cohen wrote:
> > > Is this a known issue being worked currently?
> > 
> > Yah; could you try current linus.git ? Others report that that tree now
> > works and I think I know what it the root cause of all this.
> 
> Looks like this issue went away on currentl Linus' tree.
> 
> > 
> > All I need to do is figure out a sane patch for .13 and .14 :/
> 
> I can help with the tests.

Just for the records, this thread's issue was solved by the same
solution in here:
https://lkml.org/lkml/2014/4/8/236

Br, David
