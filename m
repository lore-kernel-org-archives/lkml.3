Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbaHANVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 09:21:23 -0400
Received: from one.firstfloor.org ([193.170.194.197]:54385 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbaHANVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 09:21:22 -0400
Date: Fri, 1 Aug 2014 15:21:20 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: kan.liang@intel.com, andi@firstfloor.org,
        alexander.shishkin@linux.intel.com, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/3] x86 perf: Protect LBR msrs accessing against
 potential #GP
Message-ID: <20140801132120.GO18735@two.firstfloor.org>
References: <1406799663-18192-1-git-send-email-kan.liang@intel.com>
 <1406799663-18192-2-git-send-email-kan.liang@intel.com>
 <20140801073825.GG19379@twins.programming.kicks-ass.net>
 <20140801074430.GB3588@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140801074430.GB3588@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > NAK!
> > 
> > I already said this isn't going to ever happen.
> > 
> > Both PT and LBR are arbitrated through the kernel, therefore we can (and
> > must) deny PT when there's existing LBR usage and vice versa.
> > 
> > We will not hijack resources like this full stop end of story.
> > 
> > Fuck hardware/BIOS, they should _NOT_ be touching this.
> > 
> > The 3 people in the world with access to an x86 hardware debugger had
> > better be competent and know WTF they're doing and the BIOS can just
> > piss off right now, they should not be touching this _EVER_.


So you realize that hardware level debugging becomes impossible
if everyone starts using perf?

I dont know how anyone can construct essentially sabotaging powerful
debugging techniques ever as a good thing. In the end it'll just
lead to more buggy software (and likely hardware) for everyone.


> 
> I yelled at BIOS engineers over their PMU usage and $vendor added a BIOS
> knob to disable that, I'll yell at BIOS engineers again, just give me
> their number.
> 
> Really, say NO already.

Ok, so no technical reason, merely a "me vs you" power play.

Thank you for not stating that earlier and wasting everyone's time.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
