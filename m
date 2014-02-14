Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaBNVTa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:19:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55722 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896AbaBNVT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:19:26 -0500
Date: Fri, 14 Feb 2014 22:19:17 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <bitbucket@online.de>,
        X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] sched: Add a new lockless wake-from-idle implementation
Message-ID: <20140214211917.GE14089@laptop.programming.kicks-ass.net>
References: <20140212201709.GB6835@laptop.programming.kicks-ass.net>
 <218b548b69479baa005af8a7b04a3abbea8ed6fa.1392252790.git.luto@amacapital.net>
 <20140213145016.GA15586@twins.programming.kicks-ass.net>
 <CALCETrUOm7uRb1eUctPS5WCQkZDRZjOxyGyYb0BkGu+W-J0zpg@mail.gmail.com>
 <CALCETrUuC1t-SB1tRNBmH_=RhkRT5uprtAUQy82by5QZBJWiwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUuC1t-SB1tRNBmH_=RhkRT5uprtAUQy82by5QZBJWiwA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 12:17:27PM -0800, Andy Lutomirski wrote:
> Either you have a bug or I rebased it wrong.  With the attached
> rebased version, I hit WARN_ON_ONCE(irqs_disabled()) in
> cpu_idle_loop() on a semi-regular basis when I boot with:

Its got a bug; I got it too, but it did boot and build the next kernel.

I didn't get any time today to look at things; I'll try and prod at
things a bit more next week.


