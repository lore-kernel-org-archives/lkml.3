Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935773AbaH0SvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:51:11 -0400
Received: from www.linutronix.de ([62.245.132.108]:35313 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935147AbaH0SvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:51:09 -0400
Date: Wed, 27 Aug 2014 20:50:55 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: peterz@infradead.org, linux-kernel@vger.kernel.org, mingo@kernel.org,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/5] perf, x86: Remove incorrect model number from Haswell
 perf
In-Reply-To: <20140827163728.GQ4120@two.firstfloor.org>
Message-ID: <alpine.DEB.2.10.1408272047360.3323@nanos>
References: <1409006611-30741-1-git-send-email-andi@firstfloor.org> <1409006611-30741-2-git-send-email-andi@firstfloor.org> <alpine.DEB.2.10.1408262325200.3323@nanos> <20140826212934.GP4120@two.firstfloor.org> <alpine.DEB.2.10.1408270020020.3323@nanos>
 <alpine.DEB.2.10.1408271144580.3323@nanos> <20140827163728.GQ4120@two.firstfloor.org>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, Andi Kleen wrote:
> On Wed, Aug 27, 2014 at 11:53:57AM +0200, Thomas Gleixner wrote:
> > Try again when you figured yourself out what number means what and why
> > 71 is bogus.
> 
> 71 is definitely not a Haswell, but a Broadwell.

Fine. So the changelog should tell so.
 
> However it was removed from the Broadwell patch based on Peter's
> feedback.
> 
> So technically the patch is not needed right now because there 
> would be no duplicates (unless 71 was readded), so the compiler
> would not complain.

It's very well technically needed simply because its not a haswell and
if it's run on real model 71 hardware we'll get some interesting stuff
to debug.
 
> However it's still incorrect for Haswell, so I maintain removing
> it is the right thing to do.

I did not argue against the removal itself. That's fine and obviously
correct if model 71 is not a haswell. All I want is a proper patch (1
line) and a proper changelog explaining WHY this is the right thing to
do.

Thanks,

	tglx

