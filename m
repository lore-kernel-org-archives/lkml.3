Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764778Ab3DDTxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 15:53:48 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:38578 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764711Ab3DDTxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 15:53:47 -0400
MIME-Version: 1.0
X-Originating-IP: [217.132.7.209]
In-Reply-To: <0000013dd64a36f3-60dd0774-a44b-4780-93b7-af6b8baac87f-000000@email.amazonses.com>
References: <1364993190-13784-1-git-send-email-fweisbec@gmail.com>
	<0000013dd63de989-c6980852-2aac-4597-ba34-3b2efaa24c17-000000@email.amazonses.com>
	<CAOtvUMcs5F89biz_xtVSBAPVftfJk+0VDvxLfm7-kQ3q6x0Ynw@mail.gmail.com>
	<0000013dd64a36f3-60dd0774-a44b-4780-93b7-af6b8baac87f-000000@email.amazonses.com>
Date: Thu, 4 Apr 2013 22:48:20 +0300
Message-ID: <CAOtvUMfiaKKRpPGK_MH7364RhB_7VXzcWMBNNJNaSSM6upEngw@mail.gmail.com>
Subject: Re: [RFC GIT PULL] nohz: Kconfig layout improvements
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[ Sorry for dropping LKML on my previous email. It was caused by
replying from my smartphone. Adding everyone back now ]

On Thu, Apr 4, 2013 at 9:23 PM, Christoph Lameter <cl@linux.com> wrote:
>
> On Thu, 4 Apr 2013, Gilad Ben-Yossef wrote:
>
> > The vmstat work item leaving a timer running on the CPU, perhaps?
>
> Of course there is always a timer running for VM work.
>
> > Check /proc/timers
>
> Not compiled in.
>
> > I've sent a patch previously to make vmstat disable the timer if no VM work
> > has been detected since the last run. Maybe you can try it? It was against
> > 3.4 though. Probably won't apply...
>
> Can you repost it? CC me on future postings. I wrote the vmstat handling.
>

Here is the last version I posted over a year ago. You were CCed and
provided very useful feedback:

http://lkml.indiana.edu/hypermail/linux/kernel/1205.0/01291.html

Based on your feedback I re-spun them but never gotten around to port
them to recent kernel and post them. The latest (yet unpublished
versions) are here:

https://github.com/gby/linux/commit/04e041327036772383c14ebdc450f522d782f264
https://github.com/gby/linux/commit/f5b8ae815670a289af9ff22ad83da3295472e63c

I'll try to resurrect them, but maybe they'll prove useful as a
reference as they are in the meantime.

Hope it helps,
Gilad


--
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
