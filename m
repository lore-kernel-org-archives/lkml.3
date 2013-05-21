Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab3EUUFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 16:05:08 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:57229 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836Ab3EUUFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 16:05:05 -0400
MIME-Version: 1.0
In-Reply-To: <1369160653.6828.151.camel@gandalf.local.home>
References: <1369158390.6828.148.camel@gandalf.local.home>
	<CAFTL4hyWAJyOs3NnqSOt1JQHTk4vRiGWz6xE1bDXsVWi6fQKrQ@mail.gmail.com>
	<1369160653.6828.151.camel@gandalf.local.home>
Date: Tue, 21 May 2013 22:05:03 +0200
Message-ID: <CAFTL4hyvWUDjjVe+EAOXQgor4GvZLKJx8KJbO46+5JYRtiso2Q@mail.gmail.com>
Subject: Re: [PATCH][3.10] nohz: Fix lockup on restart from wrong error code
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/21 Steven Rostedt <rostedt@goodmis.org>:
> On Tue, 2013-05-21 at 20:12 +0200, Frederic Weisbecker wrote:
>
>> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>>
>> There has been this patch that makes it return -EPERM instead:
>> https://lkml.org/lkml/2013/5/20/386
>>
>> Not sure which is best. Both sort of make sense to me.
>
> That's just as good, as it also fixes the issue.
>
> You can take Li's and add my Acked-by to it. And perhaps even add some
> of my change log as well.

Ok, thanks!
