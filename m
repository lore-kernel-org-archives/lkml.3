Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab3FJVPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 17:15:34 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:59931 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763Ab3FJVPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 17:15:32 -0400
Date: Mon, 10 Jun 2013 14:15:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, peterz@infradead.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu,
        torvalds@linux-foundation.org
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
Message-ID: <20130610211520.GQ5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130609193657.GA13392@linux.vnet.ibm.com>
 <1370897278.9844.115.camel@gandalf.local.home>
 <alpine.LFD.2.02.1306102250590.22970@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1306102250590.22970@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061021-5806-0000-0000-000021A31C12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 11:01:50PM +0200, Thomas Gleixner wrote:
> On Mon, 10 Jun 2013, Steven Rostedt wrote:
> > On Sun, 2013-06-09 at 12:36 -0700, Paul E. McKenney wrote:
> > > +#ifdef __BIG_ENDIAN__
> > 
> > Is there such a thing as a BIG_ENDIAN x86 box? This is in
> > arch/x86/include/asm/spinlock_types.h
> 
> That's just an habit for people who have been forced to deal with BE
> CPUs.
> 
> The sad thing is that BE CPUs have been designed by folks who blindly
> expanded BCD computing without understanding the hardware
> implications.
> 
> Unfortunately they managed to inflict BE to the network protocols
> which in turn manifested the only excuse of keeping the BE nonsense
> alive.

Hey, we had to do -something-, after all, EBCDIC lost out to ASCII!!!  ;-)

							Thanx, Paul

