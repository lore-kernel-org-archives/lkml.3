Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaIJOWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:22:42 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40178 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaIJOWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:22:40 -0400
Date: Wed, 10 Sep 2014 16:22:32 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, eranian@google.com, tglx@linutronix.de
Subject: Re: [PATCH 2/2] perf, x86: Use INTEL_FLAGS_UEVENT_CONSTRAINT for
 PRECDIST
Message-ID: <20140910142232.GC4783@worktop.ger.corp.intel.com>
References: <1410310148-26260-1-git-send-email-andi@firstfloor.org>
 <1410310148-26260-2-git-send-email-andi@firstfloor.org>
 <20140910075926.GM6758@twins.programming.kicks-ass.net>
 <20140910140258.GI5387@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910140258.GI5387@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 07:02:58AM -0700, Andi Kleen wrote:
> On Wed, Sep 10, 2014 at 09:59:26AM +0200, Peter Zijlstra wrote:
> > On Tue, Sep 09, 2014 at 05:49:08PM -0700, Andi Kleen wrote:
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > The earlier commit 86a04461a made near all PEBS on
> > > Sandy/IvyBridge/Haswell to reject non zero flags.
> > 
> > What's magic about nehalem and westmere?
> 
> I wasn't able to confirm their behavior explicitly, so I felt
> it best to leave them alone.
> 
> But in principle adding the _FLAGS changes there too would
> make sense too.

Yeah please do that patch ASAP, having PEBS behave differently across
uarchs is wrong.
