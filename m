Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab3IIRGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 13:06:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32544 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab3IIRGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 13:06:08 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=JDfofD-L5ZgA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5p3hctMY2UsA:10 a=VnNF1IyMAAAA:8 a=OcKRC6gwJ1TPcsv3C5oA:9 a=CjuIK1q_8ugA:10 a=MJhe3DDrq9EA:10 a=KxqS7gh_mc4A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 9 Sep 2013 13:06:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        sbw@mit.edu
Subject: Re: [PATCH] rcu: Is it safe to enter an RCU read-side critical
 section?
Message-ID: <20130909130605.29ee8fd6@gandalf.local.home>
In-Reply-To: <20130909165836.GB3966@linux.vnet.ibm.com>
References: <20130909083926.3eceebef@gandalf.local.home>
	<20130909124547.GB16280@somewhere>
	<20130909085504.2ddd7e69@gandalf.local.home>
	<20130909130851.GC16280@somewhere>
	<20130909092142.05780991@gandalf.local.home>
	<20130909134505.GF16280@somewhere>
	<20130909135656.GT3966@linux.vnet.ibm.com>
	<20130909101629.32df27a2@gandalf.local.home>
	<20130909161708.GX3966@linux.vnet.ibm.com>
	<20130909123422.7936e868@gandalf.local.home>
	<20130909165836.GB3966@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Sep 2013 09:58:36 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:


> > "rcu_is_ignored()" or "rcu_is_not_active()", "rcu_is_watching_you()"
> 
> You know, I am strongly tempted by "rcu_is_watching_you()", but I have
> this feeling that it is too cute for its own good.  ;-)

Sign of the times...

s/c/S/
s/r/N/
s/u/A/

-- Steve
