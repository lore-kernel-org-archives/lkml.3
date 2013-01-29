Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753772Ab3A2RI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 12:08:58 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12765 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab3A2RI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 12:08:56 -0500
X-Authority-Analysis: v=2.0 cv=QcjkT7nv c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=9Wk9NYerj9wA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=O1YP5waFyKMA:10 a=cOJAhGf0KLDm15iJO90A:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359479334.17639.47.camel@gandalf.local.home>
Subject: Re: [GIT PULL] cputime: Full dynticks task/cputime accounting v7
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
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
Date: Tue, 29 Jan 2013 12:08:54 -0500
In-Reply-To: <CAFTL4hwx+e3X74Lzi-QTsEwkKicRo7EeFspza5ZNeeboSLt8KQ@mail.gmail.com>
References: <1359399845-10568-1-git-send-email-fweisbec@gmail.com>
	 <1359417749.17639.6.camel@gandalf.local.home>
	 <1359426979.17639.10.camel@gandalf.local.home>
	 <CAFTL4hwbbLoPYwvyEUYyn2EuEj=2nw2NPehe8G4rykRTE3LziA@mail.gmail.com>
	 <1359427458.17639.12.camel@gandalf.local.home>
	 <CAFTL4hxHUoFchx9wkvfLvOPVRq+P3VSHiZoPRnMJ4YdvzN=TWQ@mail.gmail.com>
	 <1359434299.17639.13.camel@gandalf.local.home>
	 <CAFTL4hxfd_xr-X4dj_4bdeYb3YBCCJkYwnciZ939ee1PXbpNYg@mail.gmail.com>
	 <1359477963.17639.46.camel@gandalf.local.home>
	 <CAFTL4hwx+e3X74Lzi-QTsEwkKicRo7EeFspza5ZNeeboSLt8KQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-01-29 at 17:55 +0100, Frederic Weisbecker wrote:

> 
> > Perhaps the best thing to do is to have the irq vtime determine usermode
> > or not with "user_mode(get_irq_regs())". I'll try it.
> 
> That will get rid of those few microsecond error margin but I bet
> that's not where the issue is.

Yep, you're right. Time to dig further ;-)

-- Steve


