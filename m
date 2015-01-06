Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbbAFKGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 05:06:39 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:55390 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbbAFKGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 05:06:38 -0500
Date: Tue, 6 Jan 2015 11:06:21 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kent Overstreet <kmo@daterainc.com>, Chris Mason <clm@fb.com>
Subject: Re: Linux 3.19-rc3
Message-ID: <20150106100621.GL29390@twins.programming.kicks-ass.net>
References: <CA+icZUU4ALYvEq7SkUewnZytf62R0d9x+MVPvMrR0zzFf+-f3Q@mail.gmail.com>
 <20150106094039.GI29390@twins.programming.kicks-ass.net>
 <CA+icZUUcgP=nUPCOfEJrbO9OAAPLgQd8RWO-BJe+W0wi3fWiOw@mail.gmail.com>
 <CA+icZUUThdtXkRztRxk+zEqvMwUmEQeSoR3WD3qqXW9QspBoVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUUThdtXkRztRxk+zEqvMwUmEQeSoR3WD3qqXW9QspBoVw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 10:57:19AM +0100, Sedat Dilek wrote:
> [   88.028739]  [<ffffffff8124433f>] aio_read_events+0x4f/0x2d0
> 

Ah, that one. Chris Mason and Kent Overstreet were looking at that one.
I'm not touching the AIO code either ;-)
