Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab3EUSYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 14:24:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29779 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab3EUSYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 14:24:15 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=2NodtjdxwxgA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=PteY7aBlQa0A:10 a=D19gQVrFAAAA:8 a=pybUgtYrGUuIQH5ClxkA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369160653.6828.151.camel@gandalf.local.home>
Subject: Re: [PATCH][3.10] nohz: Fix lockup on restart from wrong error code
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tejun Heo <tj@kernel.org>
Date: Tue, 21 May 2013 14:24:13 -0400
In-Reply-To: <CAFTL4hyWAJyOs3NnqSOt1JQHTk4vRiGWz6xE1bDXsVWi6fQKrQ@mail.gmail.com>
References: <1369158390.6828.148.camel@gandalf.local.home>
	 <CAFTL4hyWAJyOs3NnqSOt1JQHTk4vRiGWz6xE1bDXsVWi6fQKrQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-21 at 20:12 +0200, Frederic Weisbecker wrote:

> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> There has been this patch that makes it return -EPERM instead:
> https://lkml.org/lkml/2013/5/20/386
> 
> Not sure which is best. Both sort of make sense to me.

That's just as good, as it also fixes the issue.

You can take Li's and add my Acked-by to it. And perhaps even add some
of my change log as well. I believe that will still give the same
problem with reboot, which needs to be fixed.

-- Steve


