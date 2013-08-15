Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231Ab3HODcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 23:32:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22367 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759868Ab3HODcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 23:32:31 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=KpzchuzAFZgA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ce-1e7Iquy0A:10 a=Tty9oNO6AAAA:8 a=y7q6NGU4C3mMHbalK-cA:9 a=CjuIK1q_8ugA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 14 Aug 2013 23:32:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        chris <chris@chris-wilson.co.uk>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH][RFC] tracing: Enable tracepoints via module parameters
Message-ID: <20130814233228.778f25d0@gandalf.local.home>
In-Reply-To: <87siybk8yl.fsf@rustcorp.com.au>
References: <1299622684.20306.77.camel@gandalf.stny.rr.com>
	<877hc64klm.fsf@rustcorp.com.au>
	<20130813111442.632f3421@gandalf.local.home>
	<87siybk8yl.fsf@rustcorp.com.au>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Aug 2013 11:32:10 +0930
Rusty Russell <rusty@rustcorp.com.au> wrote:

> Steven Rostedt <rostedt@goodmis.org> writes:
> > But the thing about this that bothers me is that there's no way to say,
> > "Enable all tracepoints in this module on load". I would like a way to
> > do that, but I don't know of a way to do that without modifying the
> > module code. Have any ideas? Basically, I would love to have:
> >
> > insmod foo tracepoints=all
> >
> > or something and have all tracepoints enabled.
> 
> "without modifying the module code"?  Why?  The code isn't that scary,
> and this seems useful.

I'm not afraid of the code, I'm afraid of you ;-) I hear you have
killer puppies.


OK, then when I get some time, I may cook something up.

Thanks,

-- Steve
