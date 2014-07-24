Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934417AbaGXTGD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 15:06:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934351AbaGXTGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 15:06:00 -0400
Date: Thu, 24 Jul 2014 21:03:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        tkhai@yandex.ru
Subject: Re: [PATCH 2/5] sched: Teach scheduler to understand
	ONRQ_MIGRATING state
Message-ID: <20140724190342.GA26611@redhat.com>
References: <20140722102425.29682.24086.stgit@tkhai> <1406028616.3526.20.camel@tkhai> <20140722114542.GG20603@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722114542.GG20603@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh, sorry for delay, I didn't even try to read most of my emails
several days.

On 07/22, Peter Zijlstra wrote:
>
> more details is better ;-) Also, I think Oleg enjoys these kind of
> things, so I've added him to the CC.

Thanks. Trust me, at least I like this much more than what I had to
do this week ;)

This change depends on the previous patches and I am too lazy to try
to find/download the full series.

Kirill, since you are going to send v2, could you cc me? No, it is not
that I think I can help or even review (or may be even understand ;)
But this looks interesting to me, I'd like to know about these changes.

Oleg.

