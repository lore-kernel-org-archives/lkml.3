Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab3A2D35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 22:29:57 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:38634 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab3A2D3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 22:29:54 -0500
MIME-Version: 1.0
In-Reply-To: <1359427458.17639.12.camel@gandalf.local.home>
References: <1359399845-10568-1-git-send-email-fweisbec@gmail.com>
	<1359417749.17639.6.camel@gandalf.local.home>
	<1359426979.17639.10.camel@gandalf.local.home>
	<CAFTL4hwbbLoPYwvyEUYyn2EuEj=2nw2NPehe8G4rykRTE3LziA@mail.gmail.com>
	<1359427458.17639.12.camel@gandalf.local.home>
Date: Tue, 29 Jan 2013 04:29:52 +0100
Message-ID: <CAFTL4hxHUoFchx9wkvfLvOPVRq+P3VSHiZoPRnMJ4YdvzN=TWQ@mail.gmail.com>
Subject: Re: [GIT PULL] cputime: Full dynticks task/cputime accounting v7
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sedat Dilek <sedat.dilek@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/29 Steven Rostedt <rostedt@goodmis.org>:
> On Tue, 2013-01-29 at 03:39 +0100, Frederic Weisbecker wrote:
>
>> Please send me your kernelspin so I can test as well.
>
> http://rostedt.homelinux.com/private/kernelspin.c

I can't reproduce your issue. I'm getting almost the same results with
vtime + force context tracking and tick based cputime.

3 runs with tick based cputime:

real	0m10.005s
user	0m0.210s
sys	0m9.780s

real	0m10.005s
user	0m0.170s
sys	0m9.820s

real	0m10.005s
user	0m0.130s
sys	0m9.860s

3 runs with vtime + context tracking forced:

real	0m10.005s
user	0m0.807s
sys	0m9.197s

real	0m10.005s
user	0m0.832s
sys	0m9.172s

real	0m10.005s
user	0m0.787s
sys	0m9.218s


> http://rostedt.homelinux.com/private/userspin.c
>
> -- Steve
>
>
