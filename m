Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633Ab3AOLY5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 06:24:57 -0500
Received: from www.linutronix.de ([62.245.132.108]:34823 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab3AOLY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 06:24:56 -0500
Date: Tue, 15 Jan 2013 12:24:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Rutland <mark.rutland@arm.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "nico@linaro.org" <nico@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>
Subject: Re: [PATCHv2 1/4] clockevents: Add generic timer broadcast
 receiver
In-Reply-To: <20130114153612.GF7990@e106331-lin.cambridge.arm.com>
Message-ID: <alpine.LFD.2.02.1301151224300.7475@ionos>
References: <1357742770-15028-1-git-send-email-mark.rutland@arm.com> <1357742770-15028-2-git-send-email-mark.rutland@arm.com> <alpine.LFD.2.02.1301141204421.7475@ionos> <20130114112951.GC7990@e106331-lin.cambridge.arm.com> <alpine.LFD.2.02.1301141247020.7475@ionos>
 <20130114121247.GD7990@e106331-lin.cambridge.arm.com> <alpine.LFD.2.02.1301141318460.7475@ionos> <20130114153612.GF7990@e106331-lin.cambridge.arm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2013, Mark Rutland wrote:
> On Mon, Jan 14, 2013 at 02:17:26PM +0000, Thomas Gleixner wrote:
> > > I thought this previously also [1], but I couldn't find any path such that a
> > > tick_cpu_device would have an evtdev without an event_handler. We always set the
> > > handler before setting evtdev, and alway wipe evtdev before wiping the handler.
> > > 
> > > Have I missed something?
> > 
> > That's an x86 specific issue. Though we could try and make that
> > functionality completely generic.
> 
> Just to check: is the evt->event_handler check necessary?

For x86 yes. See the comment.

Thanks,

	tglx
