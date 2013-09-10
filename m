Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab3IJMzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:55:47 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:61873 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab3IJMzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:55:36 -0400
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <CALkWK0k3pJKXCsO6Nn6arm9TZCUazNdW_HrVvsa3XNnh2T8WMA@mail.gmail.com>
References: <20130903132933.GA24955@gmail.com>
	<CA+55aFxBTjfx304zstOVq3Hm3vmjgC5gOJaxXG5E_iWq_WXGTw@mail.gmail.com>
	<20130909100544.GI31370@twins.programming.kicks-ass.net>
	<CAMsRxfLEO15kKrbmtKKXuW-JTtCCgiuXS6wFs9kiLmG1wge24A@mail.gmail.com>
	<20130910115306.GA6091@gmail.com>
	<CAMsRxfLvbExOzjz8tQu7AchQgKBh5S4b7VMQmFtr1RxK4ksAvA@mail.gmail.com>
	<CALkWK0k3pJKXCsO6Nn6arm9TZCUazNdW_HrVvsa3XNnh2T8WMA@mail.gmail.com>
Date: Tue, 10 Sep 2013 05:55:35 -0700
Message-ID: <CAMsRxfLn7D-ON=gfrxttA5okPg=pyB_a-hHMBPVwGgO1_yHXYQ@mail.gmail.com>
Subject: Re: PEBS bug on HSW: "Unexpected number of pebs records 10" (was: Re:
 [GIT PULL] perf changes for v3.12)
From: Stephane Eranian <eranian@googlemail.com>
To: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 5:51 AM, Ramkumar Ramachandra
<artagnon@gmail.com> wrote:
> Stephane Eranian wrote:
>> a simple multithreaded program where
>> #threads >> #CPUs
>
> To put it another way, does Intel's HT work for CPU intensive and IO
> minimal tasks? I think HT assumes some amount of inefficient IO
> coupled with pure CPU usage.

But your remark has nothing to do with the PMU issue.
