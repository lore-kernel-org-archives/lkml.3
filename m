Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbaDHXPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 19:15:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:52891 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756798AbaDHXPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 19:15:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,819,1389772800"; 
   d="scan'208";a="489452072"
Date: Tue, 8 Apr 2014 13:13:04 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org,
        kpreempt-tech@lists.sourceforge.net
Subject: Re: Soft lockup regression since kernel 3.13
Message-ID: <20140408201304.GC5332@psi-dev26.jf.intel.com>
References: <20140402232948.GA4725@psi-dev26.jf.intel.com>
 <20140408084935.GM11096@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140408084935.GM11096@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 08, 2014 at 10:49:35AM +0200, Peter Zijlstra wrote:
> On Wed, Apr 02, 2014 at 04:29:48PM -0700, David Cohen wrote:
> > Is this a known issue being worked currently?
> 
> Yah; could you try current linus.git ? Others report that that tree now
> works and I think I know what it the root cause of all this.

Looks like this issue went away on currentl Linus' tree.

> 
> All I need to do is figure out a sane patch for .13 and .14 :/

I can help with the tests.

BR, David

