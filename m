Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbaIJUjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 16:39:08 -0400
Received: from www.linutronix.de ([62.245.132.108]:35974 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753578AbaIJUjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 16:39:05 -0400
Date: Wed, 10 Sep 2014 22:38:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@linux.intel.com>
cc: Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com
Subject: Re: [PATCH 2/2] perf, x86: Use INTEL_FLAGS_UEVENT_CONSTRAINT for
 PRECDIST
In-Reply-To: <20140910140258.GI5387@tassilo.jf.intel.com>
Message-ID: <alpine.DEB.2.10.1409102236120.4178@nanos>
References: <1410310148-26260-1-git-send-email-andi@firstfloor.org> <1410310148-26260-2-git-send-email-andi@firstfloor.org> <20140910075926.GM6758@twins.programming.kicks-ass.net> <20140910140258.GI5387@tassilo.jf.intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Sep 2014, Andi Kleen wrote:
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

Can you please once in a while come up with a precise answer to a
question instead of wrapping your internal knowledge into "in
principle", "would" and other magic keywords?

Thanks

	tglx
