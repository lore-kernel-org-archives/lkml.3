Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118Ab3HMXKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 19:10:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7933 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605Ab3HMXJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 19:09:59 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=KpzchuzAFZgA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ce-1e7Iquy0A:10 a=7d_E57ReAAAA:8 a=_WYZkrhRpS74BtdmUsIA:9 a=CjuIK1q_8ugA:10 a=D6-X0JM3zdQA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 13 Aug 2013 19:09:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        chris <chris@chris-wilson.co.uk>
Subject: Re: [PATCH][RFC] tracing: Enable tracepoints via module parameters
Message-ID: <20130813190956.2ec89dff@gandalf.local.home>
In-Reply-To: <20130813223453.GB15394@Krystal>
References: <1299622684.20306.77.camel@gandalf.stny.rr.com>
	<877hc64klm.fsf@rustcorp.com.au>
	<20130813111442.632f3421@gandalf.local.home>
	<20130813223453.GB15394@Krystal>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Aug 2013 18:34:53 -0400
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:


> What I like about this approach, if applied to kernel modules, is that
> it does not require users to interact with module load parameters to
> specify which tracepoints should be enabled: this is all done through
> the regular tracer UI, thus greatly improving user experience.
> 

I have thought about adding a file that would let you enable generic
tracepoints as they are created. Doesn't even need to be specifically
modules, but kprobes as well.

But that's agnostic to this patch. One thing I like about the patch is
that it has modinfo show you the available tracepoints in a module.

-- Steve

