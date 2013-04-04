Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764647Ab3DDUJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 16:09:40 -0400
Received: from a9-70.smtp-out.amazonses.com ([54.240.9.70]:35014 "EHLO
	a9-70.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763750Ab3DDUJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 16:09:39 -0400
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Apr 2013 16:09:39 EDT
Date: Thu, 4 Apr 2013 20:03:15 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Geoff Levand <geoff@infradead.org>, Hakan Akkan <hakanakkan@gmail.com>,
        Kevin Hilman <khilman@linaro.org>, Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Michal Marek <mmarek@suse.cz>
Subject: Re: [RFC GIT PULL] nohz: Kconfig layout improvements
In-Reply-To: <CAOtvUMfiaKKRpPGK_MH7364RhB_7VXzcWMBNNJNaSSM6upEngw@mail.gmail.com>
Message-ID: <0000013dd6a56276-65176063-1af7-46a5-93d5-c34f4a03c6ca-000000@email.amazonses.com>
References: <1364993190-13784-1-git-send-email-fweisbec@gmail.com> <0000013dd63de989-c6980852-2aac-4597-ba34-3b2efaa24c17-000000@email.amazonses.com> <CAOtvUMcs5F89biz_xtVSBAPVftfJk+0VDvxLfm7-kQ3q6x0Ynw@mail.gmail.com>
 <0000013dd64a36f3-60dd0774-a44b-4780-93b7-af6b8baac87f-000000@email.amazonses.com> <CAOtvUMfiaKKRpPGK_MH7364RhB_7VXzcWMBNNJNaSSM6upEngw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.04.04-54.240.9.70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Apr 2013, Gilad Ben-Yossef wrote:

> Here is the last version I posted over a year ago. You were CCed and
> provided very useful feedback:
>
> http://lkml.indiana.edu/hypermail/linux/kernel/1205.0/01291.html

Ah. yes I remember now.

> Based on your feedback I re-spun them but never gotten around to port
> them to recent kernel and post them. The latest (yet unpublished
> versions) are here:
>
> https://github.com/gby/linux/commit/04e041327036772383c14ebdc450f522d782f264
> https://github.com/gby/linux/commit/f5b8ae815670a289af9ff22ad83da3295472e63c
>
> I'll try to resurrect them, but maybe they'll prove useful as a
> reference as they are in the meantime.

I think that would be very useful.

