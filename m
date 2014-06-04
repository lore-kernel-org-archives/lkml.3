Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735AbaFDVXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:23:00 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:51090 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbaFDVW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:22:59 -0400
MIME-Version: 1.0
In-Reply-To: <20140604172220.GI13930@laptop.programming.kicks-ass.net>
References: <20140603114821.GA23711@gmail.com>
	<1401832251.8843.3.camel@buesod1.americas.hpqcorp.net>
	<20140604103003.GE11096@twins.programming.kicks-ass.net>
	<CA+55aFzTGHrR2dr64BsMOE--QXqw_=mwqypmweebRe-1UkJGZA@mail.gmail.com>
	<20140604172220.GI13930@laptop.programming.kicks-ass.net>
Date: Wed, 4 Jun 2014 14:22:58 -0700
X-Google-Sender-Auth: JzOE9xpGmtHBVYaNpZ5whRAphmQ
Message-ID: <CA+55aFzsTqKhAOwEm+-M_ELzRFvPMYtUn8DNM9FiUMzaeZP0pw@mail.gmail.com>
Subject: Re: [GIT PULL] locking tree changes for v3.16
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>, Peter Anvin <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 10:22 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> I _think_ tip/locking/core is empty and you could pull that into your
> tree without getting tons of extra weird stuff, but if you prefer a tree
> based on your git tree I'll have to do some manual stuff but that is
> certainly possible.

I'd actually prefer against something like the v3.15-rc8 tag, just so
that the tree is otherwise "pristine".

> Also, this 'obviously' does not have the normal tip build coverage,
> because I usually rely on the tip build robots to do that. But it does
> build and run for all my local machines.

It would be great to have Davidlohr go over it too, and if possible
have it run through the build robots. I'll pull it tomorrow or Friday
if everything looks fine, and then we'll hopefully have this issue
mostly closed.

             Linus
