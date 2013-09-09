Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab3IIQDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:03:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10827 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab3IIQDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:03:31 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=JDfofD-L5ZgA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5p3hctMY2UsA:10 a=VwQbUJbxAAAA:8 a=GO8Los9xwzcTJSYqjPoA:9 a=CjuIK1q_8ugA:10 a=LI9Vle30uBYA:10 a=M4q9alzI1soA:10 a=42w06Z-9rSEA:10 a=CeFheKej93yaGHu6:21 a=9jkSwAwDu1ysrm0M:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 9 Sep 2013 12:03:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909120328.583a586d@gandalf.local.home>
In-Reply-To: <20130909160024.GA25555@gmail.com>
References: <20130906151851.GQ3966@linux.vnet.ibm.com>
	<1378488088.31445.39.camel@edumazet-glaptop>
	<20130906174117.GU3966@linux.vnet.ibm.com>
	<20130906185927.GE2706@somewhere>
	<20130909105347.GK31370@twins.programming.kicks-ass.net>
	<20130909132343.GN3966@linux.vnet.ibm.com>
	<20130909133604.GC31370@twins.programming.kicks-ass.net>
	<000001410333127c-486c74ec-3209-4c5e-a92f-0c11e00fa141-000000@email.amazonses.com>
	<20130909150854.GD26785@twins.programming.kicks-ass.net>
	<0000014103534c88-48ee11a3-a581-4e52-b2df-3a1168047d96-000000@email.amazonses.com>
	<20130909160024.GA25555@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Sep 2013 18:00:24 +0200
Ingo Molnar <mingo@kernel.org> wrote:

> So my NAK stands: you are still in denial, you should stop the silly 
> arguing and you should stop wasting maintainer time. You need to address 
> PeterZ's review feedback and fix the bugs in your patches, ASAP.

To Christoph's credit. He did post patches with debug checks. We just
need to get around to review them.

-- Steve
