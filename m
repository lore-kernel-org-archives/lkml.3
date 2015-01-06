Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbbAFMm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 07:42:57 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:42613 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbbAFMmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 07:42:55 -0500
Date: Tue, 6 Jan 2015 04:45:28 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sedat Dilek <sedat.dilek@gmail.com>, Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Chris Mason <clm@fb.com>
Subject: Re: Linux 3.19-rc3
Message-ID: <20150106124528.GE26845@kmo-pixel>
References: <CA+icZUUcgP=nUPCOfEJrbO9OAAPLgQd8RWO-BJe+W0wi3fWiOw@mail.gmail.com>
 <CA+icZUUThdtXkRztRxk+zEqvMwUmEQeSoR3WD3qqXW9QspBoVw@mail.gmail.com>
 <20150106100621.GL29390@twins.programming.kicks-ass.net>
 <CA+icZUVy2rG3PwKhPTQojLEH2O8FD-0myO2sN8hQV4_+r9YNQQ@mail.gmail.com>
 <20150106110112.GQ29390@twins.programming.kicks-ass.net>
 <20150106110730.GA25846@kmo-pixel>
 <20150106114215.GS29390@twins.programming.kicks-ass.net>
 <20150106114842.GP10476@twins.programming.kicks-ass.net>
 <20150106120121.GB26845@kmo-pixel>
 <20150106122006.GW29390@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106122006.GW29390@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 01:20:06PM +0100, Peter Zijlstra wrote:
> We (probably me) should probably audit all the atomic_xchg()
> implementations and documentation and fix that. I was very much under
> the impression it should imply a full barrier (and it certainly does on
> x86), the documentation should state the rule that any atomic_ function
> that returns a result is fully serializing, therefore, because
> atomic_xchg() has a return value, it should too.

I think that the documentation was changed awhile ago - I'd have to check and I
should sleep, though. It was probably 4-5 years ago that I saw that old weird
"atomic_xchg() doesn't imply barriers" thing.
