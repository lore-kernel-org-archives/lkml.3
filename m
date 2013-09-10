Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab3IJNWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 09:22:23 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:44828 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab3IJNWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 09:22:20 -0400
Date: Tue, 10 Sep 2013 15:22:15 +0200
From: Ingo Molnar <mingo@kernel.org>
To: eranian@gmail.com
Cc: Ramkumar Ramachandra <artagnon@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>
Subject: Re: PEBS bug on HSW: "Unexpected number of pebs records 10" (was:
 Re: [GIT PULL] perf changes for v3.12)
Message-ID: <20130910132215.GA7537@gmail.com>
References: <20130903132933.GA24955@gmail.com>
 <CA+55aFxBTjfx304zstOVq3Hm3vmjgC5gOJaxXG5E_iWq_WXGTw@mail.gmail.com>
 <20130909100544.GI31370@twins.programming.kicks-ass.net>
 <CAMsRxfLEO15kKrbmtKKXuW-JTtCCgiuXS6wFs9kiLmG1wge24A@mail.gmail.com>
 <20130910115306.GA6091@gmail.com>
 <CAMsRxfLvbExOzjz8tQu7AchQgKBh5S4b7VMQmFtr1RxK4ksAvA@mail.gmail.com>
 <CALkWK0k3pJKXCsO6Nn6arm9TZCUazNdW_HrVvsa3XNnh2T8WMA@mail.gmail.com>
 <CAMsRxfLn7D-ON=gfrxttA5okPg=pyB_a-hHMBPVwGgO1_yHXYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMsRxfLn7D-ON=gfrxttA5okPg=pyB_a-hHMBPVwGgO1_yHXYQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@googlemail.com> wrote:

> On Tue, Sep 10, 2013 at 5:51 AM, Ramkumar Ramachandra
> <artagnon@gmail.com> wrote:
> > Stephane Eranian wrote:
> >> a simple multithreaded program where
> >> #threads >> #CPUs
> >
> > To put it another way, does Intel's HT work for CPU intensive and IO
> > minimal tasks? I think HT assumes some amount of inefficient IO
> > coupled with pure CPU usage.
> 
> But your remark has nothing to do with the PMU issue.

To quote Al Viro:

  "One name: Mark V. Shaney..."

Update your email filters if it gets annoying.

Thanks,

	Ingo
