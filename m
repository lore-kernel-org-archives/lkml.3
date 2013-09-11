Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab3IKPtT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 11:49:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28511 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab3IKPtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 11:49:18 -0400
X-Authority-Analysis: v=2.0 cv=ddwCLAre c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=JDfofD-L5ZgA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5p3hctMY2UsA:10 a=VnNF1IyMAAAA:8 a=FGRo2AM9tqashxFj-acA:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 11 Sep 2013 11:49:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130911114916.4a53f9f0@gandalf.local.home>
In-Reply-To: <20130911152331.GZ3966@linux.vnet.ibm.com>
References: <20130909161708.GX3966@linux.vnet.ibm.com>
	<20130909123422.7936e868@gandalf.local.home>
	<20130909165836.GB3966@linux.vnet.ibm.com>
	<20130909172908.GA31239@Krystal>
	<20130909175656.GF3966@linux.vnet.ibm.com>
	<20130909214026.GA8830@Krystal>
	<20130909175917.794b19bd@gandalf.local.home>
	<20130909223426.GM3966@linux.vnet.ibm.com>
	<20130911141302.GA11342@linux.vnet.ibm.com>
	<20130911102607.16a3da91@gandalf.local.home>
	<20130911152331.GZ3966@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Sep 2013 08:23:31 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> C'mon, Steven!  I did say "after treating injuries"!  In the opinion
> of the surgeon, the only option was to ampute what was left of either
> the _cpu(), _task(), _thread(), or _you().  Heck, the damage was so
> severe that we couldn't even tell which one it was!

What a morbid thought. The possibility that "_you" was amputated.

-- Steve
