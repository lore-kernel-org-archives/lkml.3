Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab3H2RdC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:33:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5218 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab3H2RdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:33:00 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=wom5GMh1gUkA:10 a=LpxhMNE_n7QA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=qNUMAmISgnoA:10 a=5gMQ7t9s4f_US2Bqg3gA:9 a=CjuIK1q_8ugA:10 a=izddD6tbeikA:10 a=ZgjvoJvUNAMA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Thu, 29 Aug 2013 13:32:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Christoph Lameter <cl@linux.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Ingo Molnar <mingo@redhat.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [gcv v3 06/35] scheduler: Replace __get_cpu_var uses
Message-ID: <20130829173256.GB6276@home.goodmis.org>
References: <20130828193457.140443630@linux.com>
 <00000140c67817eb-b582280a-f059-499f-a24c-a11f3d59b86e-000000@email.amazonses.com>
 <20130829075818.GW10002@twins.programming.kicks-ass.net>
 <20130829100143.GA29672@gmail.com>
 <00000140cb02576f-e106763c-d382-4b66-bb85-d7a9cb266b81-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000140cb02576f-e106763c-d382-4b66-bb85-d7a9cb266b81-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 04:57:43PM +0000, Christoph Lameter wrote:
> 
> We could add a ____this_cpu variant that would be used in the cases we do
> not want preemption checks? There should not be too many but it will
> mean a whole lot of new definitions in percpu.h.

Let's get away from underscores as they are meaningless.

A this_cpu_atomic() or other descriptive name would be much more
appropriate.

-- Steve

