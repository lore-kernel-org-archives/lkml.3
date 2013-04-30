Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024Ab3D3PeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 11:34:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932934Ab3D3PeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 11:34:13 -0400
Date: Tue, 30 Apr 2013 17:35:20 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] scheduler changes for v3.10
Message-ID: <20130430153512.GA21930@redhat.com>
References: <20130430065808.GA19736@gmail.com>
 <CA+55aFwcX3oKYCFbq4XcX7Y2Yk6BWWKY4TRNOyfeZ9rYrQMRNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwcX3oKYCFbq4XcX7Y2Yk6BWWKY4TRNOyfeZ9rYrQMRNQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 07:49:43AM -0700, Linus Torvalds wrote:
> On Mon, Apr 29, 2013 at 11:58 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Please pull the latest sched-core-for-linus git tree from:
> >
> > The main changes in this development cycle were:
> >
> >   - full dynticks preparatory work by Frederic Weisbecker
> 
> Why does this have the crappy cputime scaling overflow code, when we
> had a long thread about how to do it right *without* any 64-bit
> divides, including a quality-tested patch?
> 
> This still has the garbage "div64_u64_rem()" crap which actually SLOWS
> DOWN 32-bit code even when not used (becuse it makes "div64_u64()"
> calculate it even when unnecessary.
> 
> WTF happened here? I and others spent efforts so that we wouldn't need
> this kind of crap.

I'm sorry, I was on vacations and has some other work to do, so I didn't
send patches in timely manner. I just posted them today.

Stanislaw
