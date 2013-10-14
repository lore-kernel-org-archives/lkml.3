Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab3JNNJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 09:09:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755670Ab3JNNJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 09:09:40 -0400
Message-ID: <1381756142.14558.17.camel@fedora>
Subject: Re: [PATCH 0/6] percpu: Implement Preemption checks for __this_cpu
 operations V4
From: Steven Rostedt <srostedt@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: cl@linux.com, tj@kernel.org, akpm@linuxfoundation.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        tglx@linutronix.de
Date: Mon, 14 Oct 2013 09:09:02 -0400
In-Reply-To: <20131011.140814.422793173894221852.davem@davemloft.net>
References: <00000141a8a7ea27-4ab5f822-e15f-4789-a5cf-f313c402a901-000000@email.amazonses.com>
	 <20131011.140814.422793173894221852.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-10-11 at 14:08 -0400, David Miller wrote:
> 
> Most sites are rejecting your posting because the CC: list looked like this:
> 
> Cc:     akpm@linuxfoundation.org
> Cc:     Steven Rostedt <srostedt@redhat.com>

Also, please remove my Red Hat email address from your address book and
replace it with rostedt@goodmis.org instead.

I try not to do upstream work from my Red Hat account, and use that only
for Red Hat internal issues.

Thanks,

-- Steve



> Cc:     linux-kernel@vger.kernel.org
> Cc:     Ingo Molnar <mingo@kernel.org>
> Cc:     Peter Zijlstra <peterz@infradead.org>
> Cc:     Thomas Gleixner <tglx@linutronix.de>
> 
> Please only specify one CC: list with a comma separated list of recipients.
> 
> Thanks.


