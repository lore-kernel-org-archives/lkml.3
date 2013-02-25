Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759043Ab3BYVrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 16:47:22 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:40247 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921Ab3BYVrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 16:47:19 -0500
Message-ID: <512BDB61.1010204@linux.vnet.ibm.com>
Date: Tue, 26 Feb 2013 03:15:05 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, rostedt@goodmis.org,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        rjw@sisk.pl, sbw@mit.edu, fweisbec@gmail.com, linux@arm.linux.org.uk,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        walken@google.com, vincent.guittot@linaro.org
Subject: Re: [PATCH v6 00/46] CPU hotplug: stop_machine()-free CPU hotplug
References: <20130218123714.26245.61816.stgit@srivatsabhat.in.ibm.com> <87mwuxfatp.fsf@rustcorp.com.au>
In-Reply-To: <87mwuxfatp.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022521-2674-0000-0000-000007F56ACD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 06:01 AM, Rusty Russell wrote:
> "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> writes:
>> Hi,
>>
>> This patchset removes CPU hotplug's dependence on stop_machine() from the CPU
>> offline path and provides an alternative (set of APIs) to preempt_disable() to
>> prevent CPUs from going offline, which can be invoked from atomic context.
>> The motivation behind the removal of stop_machine() is to avoid its ill-effects
>> and thus improve the design of CPU hotplug. (More description regarding this
>> is available in the patches).
> 
> If you're doing a v7, please put your benchmark results somewhere!
> 

Oh, I forgot to put them in v6! Thanks for reminding :-)
And yes, I'll have to do a v7 to incorporate changes (if any) to the new code
that went in during this merge window.

> The obvious place is in the 44/46.
>

Ok, will add it there. Thank you!
 
Regards,
Srivatsa S. Bhat

