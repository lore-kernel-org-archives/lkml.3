Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499AbbATAaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 19:30:19 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:34497 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbbATAaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 19:30:17 -0500
Date: Mon, 19 Jan 2015 16:30:08 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Kent Overstreet <kmo@daterainc.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Chris Mason <clm@fb.com>
Subject: Re: Linux 3.19-rc3
Message-ID: <20150120003008.GA14445@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20150106114215.GS29390@twins.programming.kicks-ass.net>
 <20150106114842.GP10476@twins.programming.kicks-ass.net>
 <20150106120121.GB26845@kmo-pixel>
 <20150106122006.GW29390@twins.programming.kicks-ass.net>
 <54ABDB4B.7070008@hurleysoftware.com>
 <20150106173808.GB5280@linux.vnet.ibm.com>
 <54AC224C.4030903@hurleysoftware.com>
 <20150106192559.GF5280@linux.vnet.ibm.com>
 <54AC3E31.2080202@hurleysoftware.com>
 <20150106204753.GI5280@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106204753.GI5280@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012000-0017-0000-0000-00000812E028
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 12:47:53PM -0800, Paul E. McKenney wrote:
> On Tue, Jan 06, 2015 at 02:57:37PM -0500, Peter Hurley wrote:

[ . . . ]

> David Miller's call, actually.
> 
> But the rule is that if it is an atomic read-modify-write operation and it
> returns a value, then the operation itself needs to include full memory
> barriers before and after (as in the caller doesn't need to add them).
> Otherwise, the operation does not need to include memory ordering.
> Since xchg(), atomic_xchg(), and atomic_long_xchg() all return a value,
> their implementations must include full memory barriers before and after.
> 
> Pretty straightforward.  ;-)

Hello again, Peter,

Were you going to push a patch clarifying this?

							Thanx, Paul

