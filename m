Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab3HMHvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 03:51:03 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47613 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab3HMHvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 03:51:00 -0400
Date: Tue, 13 Aug 2013 09:50:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        gcc <gcc@gcc.gnu.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
Message-ID: <20130813075048.GR27162@twins.programming.kicks-ass.net>
References: <1375721715.22073.80.camel@gandalf.local.home>
 <20130812091707.GB27162@twins.programming.kicks-ass.net>
 <5208F78A.3000708@linux.intel.com>
 <20130812160950.GT3008@twins.programming.kicks-ass.net>
 <52091FB9.4080805@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52091FB9.4080805@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 10:47:37AM -0700, H. Peter Anvin wrote:
> On 08/12/2013 09:09 AM, Peter Zijlstra wrote:
> >>
> >> On the majority of architectures, including x86, you cannot simply copy
> >> a piece of code elsewhere and have it still work.
> > 
> > I thought we used -fPIC which would allow just that.
> > 
> 
> Doubly wrong.  The kernel is not compiled with -fPIC, nor does -fPIC
> allow this kind of movement for code that contains intramodule
> references (that is *all* references in the kernel).  Since we really
> doesn't want to burden the kernel with a GOT and a PLT, that is life.

OK. never mind then..
