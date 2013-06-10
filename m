Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab3FJVCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 17:02:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:58453 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab3FJVCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 17:02:04 -0400
Date: Mon, 10 Jun 2013 23:01:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, torvalds@linux-foundation.org
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
In-Reply-To: <1370897278.9844.115.camel@gandalf.local.home>
Message-ID: <alpine.LFD.2.02.1306102250590.22970@ionos>
References: <20130609193657.GA13392@linux.vnet.ibm.com> <1370897278.9844.115.camel@gandalf.local.home>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jun 2013, Steven Rostedt wrote:
> On Sun, 2013-06-09 at 12:36 -0700, Paul E. McKenney wrote:
> > +#ifdef __BIG_ENDIAN__
> 
> Is there such a thing as a BIG_ENDIAN x86 box? This is in
> arch/x86/include/asm/spinlock_types.h

That's just an habit for people who have been forced to deal with BE
CPUs.

The sad thing is that BE CPUs have been designed by folks who blindly
expanded BCD computing without understanding the hardware
implications.

Unfortunately they managed to inflict BE to the network protocols
which in turn manifested the only excuse of keeping the BE nonsense
alive.

Thanks,

	tglx
