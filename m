Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761107Ab3BJTpR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 14:45:17 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:42020 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab3BJTpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 14:45:14 -0500
Message-ID: <5117F848.1090700@linux.vnet.ibm.com>
Date: Mon, 11 Feb 2013 01:13:04 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, rostedt@goodmis.org, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, rjw@sisk.pl, sbw@mit.edu,
        fweisbec@gmail.com, linux@arm.linux.org.uk, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 14/45] rcu, CPU hotplug: Fix comment referring to stop_machine()
References: <20130122073210.13822.50434.stgit@srivatsabhat.in.ibm.com> <20130122073630.13822.99359.stgit@srivatsabhat.in.ibm.com> <20130209001439.GQ2666@linux.vnet.ibm.com>
In-Reply-To: <20130209001439.GQ2666@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021019-1396-0000-0000-00000286239E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2013 05:44 AM, Paul E. McKenney wrote:
> On Tue, Jan 22, 2013 at 01:06:34PM +0530, Srivatsa S. Bhat wrote:
>> Don't refer to stop_machine() in the CPU hotplug path, since we are going
>> to get rid of it. Also, move the comment referring to callback adoption
>> to the CPU_DEAD case, because that's where it happens now.
>>
>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> 
> Ouch!  That comment is indeed obsolete and must die.
> 
> I queued this to -rcu with your Signed-off-by.  However, I omitted
> the added comment, as it is imcomplete -- it is easy to look at
> rcu_cleanup_dead_cpu() to see what it does.
>

Cool! I'll drop it from my patch series then. Thank you!

Regards,
Srivatsa S. Bhat

