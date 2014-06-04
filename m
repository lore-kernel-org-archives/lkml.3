Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaFDQRY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:17:24 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:34728 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbaFDQRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:17:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140604103003.GE11096@twins.programming.kicks-ass.net>
References: <20140603114821.GA23711@gmail.com>
	<1401832251.8843.3.camel@buesod1.americas.hpqcorp.net>
	<20140604103003.GE11096@twins.programming.kicks-ass.net>
Date: Wed, 4 Jun 2014 09:17:20 -0700
X-Google-Sender-Auth: 3xn9XXyf0SUosnW93oAcP1e6R8A
Message-ID: <CA+55aFzTGHrR2dr64BsMOE--QXqw_=mwqypmweebRe-1UkJGZA@mail.gmail.com>
Subject: Re: [GIT PULL] locking tree changes for v3.16
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2014 at 3:30 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> Ingo is 'missing' most of the time, so while I sit here with a massive
> queue of patches its nearly impossible for me to get anything merged :-(

Ugh. I'd love to get this whole locking stuff sorted out. At worst,
could you just set up a git tree of your own with the locking patches?
Or I could even just take an emailed patch-series, although I do
prefer the convenience of a git pull.. This has been going on for a
_loong_ time now.

              Linus
