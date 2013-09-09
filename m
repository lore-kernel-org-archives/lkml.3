Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab3IIQmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 12:42:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25761 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab3IIQmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 12:42:08 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=JDfofD-L5ZgA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5p3hctMY2UsA:10 a=VnNF1IyMAAAA:8 a=7zWjzF3xIDRxBTF1BW0A:9 a=CjuIK1q_8ugA:10 a=tyIGqtuLRSMA:10 a=KxqS7gh_mc4A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 9 Sep 2013 12:42:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu, cl@linux.com
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909124205.37926095@gandalf.local.home>
In-Reply-To: <20130909162632.GZ3966@linux.vnet.ibm.com>
References: <20130905195234.GA20555@linux.vnet.ibm.com>
	<20130906105934.GF20519@somewhere>
	<20130906151851.GQ3966@linux.vnet.ibm.com>
	<1378488088.31445.39.camel@edumazet-glaptop>
	<20130906174117.GU3966@linux.vnet.ibm.com>
	<20130906185927.GE2706@somewhere>
	<20130909105347.GK31370@twins.programming.kicks-ass.net>
	<20130909132343.GN3966@linux.vnet.ibm.com>
	<20130909142155.GC26785@twins.programming.kicks-ass.net>
	<20130909162632.GZ3966@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Sep 2013 09:26:32 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:


> Now if we can agree on the naming and the exact per-CPU incantation...  ;-)

s/per-CPU/per-task/

/me runs away!!!

-- Steve
