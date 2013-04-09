Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937146Ab3DIJi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:38:57 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54994 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759861Ab3DIJiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:38:54 -0400
Date: Tue, 9 Apr 2013 10:38:36 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kevin Hilman <khilman@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 08/34] arm: Use generic idle loop
Message-ID: <20130409093836.GA14496@n2100.arm.linux.org.uk>
References: <20130321214930.752934102@linutronix.de> <20130321215233.826238797@linutronix.de> <87zjxv9lga.fsf@linaro.org> <alpine.LFD.2.02.1303251230440.22263@ionos> <20130325114808.GQ4977@n2100.arm.linux.org.uk> <alpine.LFD.2.02.1303251501520.22263@ionos> <20130408214719.GN17995@n2100.arm.linux.org.uk> <alpine.LFD.2.02.1304091106360.21884@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1304091106360.21884@ionos>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 11:20:31AM +0200, Thomas Gleixner wrote:
> On Mon, 8 Apr 2013, Russell King - ARM Linux wrote:
> > On Mon, Mar 25, 2013 at 03:02:39PM +0100, Thomas Gleixner wrote:
> > So, how can I review these changes when all there is is a git URL, and
> > I *do* not want to pull them into my tree without first looking at the
> > patches, possibly reviewing them and *replying* with the patch inline?
> 
> the patches were CC'ed to LKML and linux-arch and I expected that you
> are at least having the latter. Find the relevant patch inlined below.

I've not been on linux-arch for a few years now, after it evolved into
yet another lkml-like list with high traffic rates, where mainly specific
x86 issues seemed to be discussed, rather than it being a way to contact
all arch maintainers.

> It is a counter. I looked carefully at all the various slightly
> differently fcked up implementations and picked the counter based one
> as it fits all requirements.

Great, thanks.  The attached patch looks fine to me.
