Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab3F1Phr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 11:37:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12274 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229Ab3F1Php (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 11:37:45 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=F6bfKC6atTwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=4o3xqwvaRjkA:10 a=vajTsMwlA8KnSvEaF5kA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1372433864.18733.336.camel@gandalf.local.home>
Subject: Re: [PATCH -tip] x86,trace: Add rcu_irq_enter/exit() in
 smp_trace_reschedule_interrupt()
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Date: Fri, 28 Jun 2013 11:37:44 -0400
In-Reply-To: <20130628151906.GE6626@twins.programming.kicks-ass.net>
References: <51C8AA31.3070208@hds.com>
	 <1372429303.18733.325.camel@gandalf.local.home>
	 <20130628151906.GE6626@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-28 at 17:19 +0200, Peter Zijlstra wrote:

> Things might have changed; but you'd better remeasure if you want to go
> sweep the arch tree.

Fair enough.

-- Steve


