Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaGVKjG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:39:06 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60333 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaGVKjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:39:04 -0400
Date: Tue, 22 Jul 2014 12:38:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Bruno Wolff III <bruno@wolff.to>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Josh Boyer <jwboyer@redhat.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Scheduler regression from
 caffcdd8d27ba78730d5540396ce72ad022aff2c
Message-ID: <20140722103857.GK12054@laptop.lan>
References: <20140717123502.GL19379@twins.programming.kicks-ass.net>
 <20140718053449.GA2039@wolff.to>
 <20140718101633.GP9918@twins.programming.kicks-ass.net>
 <20140718130126.GA2401@wolff.to>
 <20140718141648.GE20603@laptop.programming.kicks-ass.net>
 <20140718145040.GG12054@laptop.lan>
 <20140718161602.GH12054@laptop.lan>
 <20140721163528.GA10433@wolff.to>
 <20140721165212.GO3935@laptop>
 <20140722094740.GJ12054@laptop.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722094740.GJ12054@laptop.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 11:47:40AM +0200, Peter Zijlstra wrote:
> On Mon, Jul 21, 2014 at 06:52:12PM +0200, Peter Zijlstra wrote:
> > On Mon, Jul 21, 2014 at 11:35:28AM -0500, Bruno Wolff III wrote:
> > > Is there more I can do to help with this now? Or should I just wait for
> > > patches to test?
> > 
> > Yeah, sorry, was wiped out today. I'll go stare harder at the P4
> > topology setup code tomorrow. Something fishy there.
> 
> Does this make your machine boot again (while giving an error)?
> 
> It tries to robustify the topology setup a bit, crashing on crap input
> should be avoided if possible of course.
> 
> I'll go stare at the x86/P4 topology code like promised.

Could you provide the output of cpuid and cpuid -r for your machine?
This code is magic and I've no idea what your machine is telling it to
do :/


