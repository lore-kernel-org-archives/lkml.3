Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab3HAKNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 06:13:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33293 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab3HAKNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 06:13:22 -0400
Date: Thu, 1 Aug 2013 12:12:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Waiman Long <Waiman.Long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        George Spelvin <linux@horizon.com>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH RFC 1/2] qspinlock: Introducing a 4-byte queue spinlock
 implementation
Message-ID: <20130801101256.GM3008@twins.programming.kicks-ass.net>
References: <1375324631-32868-1-git-send-email-Waiman.Long@hp.com>
 <1375324631-32868-2-git-send-email-Waiman.Long@hp.com>
 <20130801094029.GK3008@twins.programming.kicks-ass.net>
 <51FA3455.1000607@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FA3455.1000607@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 01, 2013 at 03:41:33PM +0530, Raghavendra K T wrote:
> It is exactly 16k-1 not 15k
> That is because CPU_CODE of 1 to 16k represents cpu 0..16k-1

>From what I know big systems are usually build with power-of-two
factors. Although I suppose with a ring fabric you could have an
arbitrary number of nodes.

Anyway, I've heard SGI talk about 4K cpu systems, 8K cpu systems and 16K
cpu systems, I've not heard them talk about 16K-n systems.

Also, as in other parts of the reply I send, this limitation seems
completely unnecessary.
