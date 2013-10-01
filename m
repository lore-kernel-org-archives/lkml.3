Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab3JAO10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 10:27:26 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:44845 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340Ab3JAO1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 10:27:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAFTL4hzxN2nj8H+ycPaFLzvM0NK5TtfWtfVJVTSEtNzofTvqSw@mail.gmail.com>
References: <52138BE9.5090005@linux.intel.com>
	<20130820160146.GG3258@twins.programming.kicks-ass.net>
	<20130820163312.GA17957@redhat.com>
	<20130820175429.GI3258@twins.programming.kicks-ass.net>
	<20130820182553.GB22287@redhat.com>
	<20130821083130.GM3258@twins.programming.kicks-ass.net>
	<20130821113551.GA1472@redhat.com>
	<20130821123311.GA31370@twins.programming.kicks-ass.net>
	<20130821142356.GC31370@twins.programming.kicks-ass.net>
	<20130821164146.GA15194@redhat.com>
	<20131001140525.GE24825@localhost.localdomain>
	<CAFTL4hzxN2nj8H+ycPaFLzvM0NK5TtfWtfVJVTSEtNzofTvqSw@mail.gmail.com>
Date: Tue, 1 Oct 2013 16:27:23 +0200
Message-ID: <CAFTL4hz6DzVF6tmjA43LcyS45iMj5W6Nd5mTYTkNUd9zp5wxgQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] nohz: Synchronize sleep time stats with seqlock
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando_b1@lab.ntt.co.jp>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/1 Frederic Weisbecker <fweisbec@gmail.com>:
> I forgot...
>               cpu_idletime->idle_start;
                 cpu_idletime->idle_start = NOW();

grrr.
