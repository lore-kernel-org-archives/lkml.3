Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444AbaAVMOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 07:14:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53593 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342AbaAVMOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 07:14:18 -0500
Date: Wed, 22 Jan 2014 13:13:39 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
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
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        George Spelvin <linux@horizon.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v9 3/5] qrwlock, x86 - Treat all data type not bigger
 than long as atomic in x86
Message-ID: <20140122121339.GM31570@twins.programming.kicks-ass.net>
References: <1389761047-47566-1-git-send-email-Waiman.Long@hp.com>
 <1389761047-47566-4-git-send-email-Waiman.Long@hp.com>
 <20140120150316.GG30183@twins.programming.kicks-ass.net>
 <52DE9410.6090500@hp.com>
 <20140121153958.GA31570@twins.programming.kicks-ass.net>
 <52DE9BB0.5070909@hp.com>
 <CA+55aFzyww_kwU36jYk=LUtxzPUU76xgnQEOUTqGMFNe80sOZA@mail.gmail.com>
 <20140122080155.GE31570@twins.programming.kicks-ass.net>
 <20140122120917.GA8894@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140122120917.GA8894@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 01:09:17PM +0100, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Tue, Jan 21, 2014 at 04:31:56PM -0800, Linus Torvalds wrote:
> > > And if somebody tries to do a "smp_store_release()" on a random
> > > structure or union, do we care? We're not some nanny state that wants
> > > to give nice warnings for insane code.
> > 
> > Hurm, and here I thought warning on insane code was a good idea :/
> 
> There's a level of insanity that is best cured through Darwin Awards?

Yeah, but who will clean up after them? :-)
