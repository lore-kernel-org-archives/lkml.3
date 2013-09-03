Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab3ICRTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 13:19:08 -0400
Received: from b232-131.smtp-out.amazonses.com ([199.127.232.131]:65358 "EHLO
	b232-131.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754111Ab3ICRTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 13:19:06 -0400
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Sep 2013 13:19:06 EDT
Date: Tue, 3 Sep 2013 17:09:47 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Steven Rostedt <rostedt@goodmis.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        akpm@linuxfoundation.org, Ingo Molnar <mingo@redhat.com>,
        linux-arch@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [gcv v3 06/35] scheduler: Replace __get_cpu_var uses
In-Reply-To: <20130903114454.2a995f41@gandalf.local.home>
Message-ID: <00000140e4cd2c8c-c0832099-97c6-47b8-9ca0-a556855a1c13-000000@email.amazonses.com>
References: <20130828193457.140443630@linux.com> <00000140c67817eb-b582280a-f059-499f-a24c-a11f3d59b86e-000000@email.amazonses.com> <20130829075818.GW10002@twins.programming.kicks-ass.net> <20130829100143.GA29672@gmail.com>
 <00000140cb02576f-e106763c-d382-4b66-bb85-d7a9cb266b81-000000@email.amazonses.com> <20130829173256.GB6276@home.goodmis.org> <00000140cb49bdde-1279ffb0-5c49-400d-970c-a481d527e98a-000000@email.amazonses.com> <20130829143053.3fc2caa8@gandalf.local.home>
 <00000140e4373c9e-ea44cb7f-985f-4d33-86ed-cfd54ec7327b-000000@email.amazonses.com> <CAFTL4hyEuePJC4GG60DqQCfu-JiV9krRCf3FwWAy15Hyzu2AUw@mail.gmail.com> <20130903114454.2a995f41@gandalf.local.home>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.127.232.131
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Sep 2013, Steven Rostedt wrote:

> Right, that's why there's a raw_smp_processor_id() and
> __raw_get_cpu_var(). Those two are the ones without checks, and they
> are called by the non "raw" versions after the check is done.
>
> Really, what's so damn hard about this?

Well you tried it before as far as I can recall. Just came back from Labor
day.  Should have something soon.

