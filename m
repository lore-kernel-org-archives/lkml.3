Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368AbaH0JyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 05:54:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:60083 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933198AbaH0JyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 05:54:12 -0400
Date: Wed, 27 Aug 2014 11:53:57 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: peterz@infradead.org, linux-kernel@vger.kernel.org, mingo@kernel.org,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/5] perf, x86: Remove incorrect model number from Haswell
 perf
In-Reply-To: <alpine.DEB.2.10.1408270020020.3323@nanos>
Message-ID: <alpine.DEB.2.10.1408271144580.3323@nanos>
References: <1409006611-30741-1-git-send-email-andi@firstfloor.org> <1409006611-30741-2-git-send-email-andi@firstfloor.org> <alpine.DEB.2.10.1408262325200.3323@nanos> <20140826212934.GP4120@two.firstfloor.org> <alpine.DEB.2.10.1408270020020.3323@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, Thomas Gleixner wrote:

> On Tue, 26 Aug 2014, Andi Kleen wrote:
> 
> > > So what's the point of making the obvious onliner patch
> > > 
> > > -	case 71:
> > > 
> > > into something which reorders the sorted case numbers?
> >  
> > This was a merging mistake. I'll fix it to be a one liner.
> > 
> > > And of course, this patch is missing any explanation WHY 71 is
> > > incorrect and how it got there in the first place.
> > 
> > 71 is a Broadwell, as you would know if you had read the next patch.
> 
> And why on earth do I need to read the next patch to figure out what
> the heck this patch is doing?
> 
> Just because it's written by someone who gives a shit?
> 
> Your unwillingness to cooperate and your advisory resistance are
> slowly approaching the Krause level...

And after reading the next patch I still can't see that 71 is a
broadwell, because the next patch merily adds haswell names to the
numbers. Neither of the following patches has the magic 71
incorporated. The only model number related to broadwell is 61 in
patch 3/5.

Try again when you figured yourself out what number means what and why
71 is bogus.

Thanks,

	tglx


