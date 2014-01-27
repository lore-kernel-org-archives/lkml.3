Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbaA0RJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:09:40 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:33137 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbaA0RJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:09:37 -0500
Date: Mon, 27 Jan 2014 09:09:31 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <waiman.long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v9 3/5] qrwlock, x86 - Treat all data type not bigger
 than long as atomic in x86
Message-ID: <20140127170931.GQ9012@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1389761047-47566-4-git-send-email-Waiman.Long@hp.com>
 <20140120150316.GG30183@twins.programming.kicks-ass.net>
 <52DE9410.6090500@hp.com>
 <20140121153958.GA31570@twins.programming.kicks-ass.net>
 <52DE9BB0.5070909@hp.com>
 <CA+55aFzyww_kwU36jYk=LUtxzPUU76xgnQEOUTqGMFNe80sOZA@mail.gmail.com>
 <20140122080155.GE31570@twins.programming.kicks-ass.net>
 <20140122120917.GA8894@gmail.com>
 <20140122121339.GM31570@twins.programming.kicks-ass.net>
 <20140122130933.GB9429@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122130933.GB9429@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012717-0928-0000-0000-000005C0EE8E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 02:09:33PM +0100, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Wed, Jan 22, 2014 at 01:09:17PM +0100, Ingo Molnar wrote:
> > > 
> > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > > On Tue, Jan 21, 2014 at 04:31:56PM -0800, Linus Torvalds wrote:
> > > > > And if somebody tries to do a "smp_store_release()" on a random
> > > > > structure or union, do we care? We're not some nanny state that wants
> > > > > to give nice warnings for insane code.
> > > > 
> > > > Hurm, and here I thought warning on insane code was a good idea :/
> > > 
> > > There's a level of insanity that is best cured through Darwin Awards?
> > 
> > Yeah, but who will clean up after them? :-)
> 
> Birds, insects, bacteria?

In the Linux kernel, it will probably be us cleaning up after them.  ;-)

								Thanx, Paul

