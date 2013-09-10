Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab3IJMvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:51:45 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:49931 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab3IJMvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:51:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAMsRxfLvbExOzjz8tQu7AchQgKBh5S4b7VMQmFtr1RxK4ksAvA@mail.gmail.com>
References: <20130903132933.GA24955@gmail.com> <CA+55aFxBTjfx304zstOVq3Hm3vmjgC5gOJaxXG5E_iWq_WXGTw@mail.gmail.com>
 <20130909100544.GI31370@twins.programming.kicks-ass.net> <CAMsRxfLEO15kKrbmtKKXuW-JTtCCgiuXS6wFs9kiLmG1wge24A@mail.gmail.com>
 <20130910115306.GA6091@gmail.com> <CAMsRxfLvbExOzjz8tQu7AchQgKBh5S4b7VMQmFtr1RxK4ksAvA@mail.gmail.com>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Tue, 10 Sep 2013 18:21:00 +0530
Message-ID: <CALkWK0k3pJKXCsO6Nn6arm9TZCUazNdW_HrVvsa3XNnh2T8WMA@mail.gmail.com>
Subject: Re: PEBS bug on HSW: "Unexpected number of pebs records 10" (was: Re:
 [GIT PULL] perf changes for v3.12)
To: eranian@gmail.com
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian wrote:
> a simple multithreaded program where
> #threads >> #CPUs

To put it another way, does Intel's HT work for CPU intensive and IO
minimal tasks? I think HT assumes some amount of inefficient IO
coupled with pure CPU usage.
