Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759492AbaGYHLP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 03:11:15 -0400
Received: from relay.parallels.com ([195.214.232.42]:54918 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758959AbaGYHLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 03:11:14 -0400
Message-ID: <1406272265.3526.95.camel@tkhai>
Subject: Re: [PATCH 2/5] sched: Teach scheduler to understand ONRQ_MIGRATING
 state
From: Kirill Tkhai <ktkhai@parallels.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, <linux-kernel@vger.kernel.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        <tkhai@yandex.ru>
Date: Fri, 25 Jul 2014 11:11:05 +0400
In-Reply-To: <20140724190342.GA26611@redhat.com>
References: <20140722102425.29682.24086.stgit@tkhai>
	 <1406028616.3526.20.camel@tkhai>
	 <20140722114542.GG20603@laptop.programming.kicks-ass.net>
	 <20140724190342.GA26611@redhat.com>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Чт, 24/07/2014 в 21:03 +0200, Oleg Nesterov пишет:
> Oh, sorry for delay, I didn't even try to read most of my emails
> several days.
> 
> On 07/22, Peter Zijlstra wrote:
> >
> > more details is better ;-) Also, I think Oleg enjoys these kind of
> > things, so I've added him to the CC.
> 
> Thanks. Trust me, at least I like this much more than what I had to
> do this week ;)
> 
> This change depends on the previous patches and I am too lazy to try
> to find/download the full series.
> 
> Kirill, since you are going to send v2, could you cc me? No, it is not
> that I think I can help or even review (or may be even understand ;)
> But this looks interesting to me, I'd like to know about these changes.

I'm going to update the series on the weekend, of course, you'll surely
be CCed :)

Regards,
	Kirill

