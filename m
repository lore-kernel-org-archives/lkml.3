Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741Ab3LMFYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 00:24:53 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:42560 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab3LMFYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 00:24:51 -0500
Message-ID: <52AA9953.9090909@linux.vnet.ibm.com>
Date: Fri, 13 Dec 2013 10:51:23 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: peterz@infradead.org, fweisbec@gmail.com, paul.gortmaker@windriver.com,
        paulus@samba.org, mingo@kernel.org, shangw@linux.vnet.ibm.com,
        rafael.j.wysocki@intel.com, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, michael@ellerman.id.au,
        john.stultz@linaro.org, tglx@linutronix.de, chenhui.zhao@freescale.com,
        deepthi@linux.vnet.ibm.com, r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC PATCH] time: Support in tick broadcast framework for archs
 without an external wakeup source
References: <20131213041901.17199.37383.stgit@preeti.in.ibm.com> <1386911862.15730.81.camel@pasglop>
In-Reply-To: <1386911862.15730.81.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121305-1344-0000-0000-00000414028B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On 12/13/2013 10:47 AM, Benjamin Herrenschmidt wrote:
> On Fri, 2013-12-13 at 09:49 +0530, Preeti U Murthy wrote:
>> On some architectures, in certain CPU deep idle states the local timers stop.
>> An external clock device is used to wakeup these CPUs. The kernel support for the
>> wakeup of these CPUs is provided by the tick broadcast framework by using the
>> external clock device as the wakeup source.
> 
>> However on architectures like PowerPC there is no external clock device. 
> 
> Minor nit ...
> 
> I wouldn't make this an architectural statement. Some PowerPC's do have
> external clock devices (for example the old MPIC interrupt controller
> had timers). In fact, if we really need it, I'm sure we *could* find
> something somewhere in P8 that could act as a timer, probably hijacking
> a bit of the OCC or similar but at this stage, that's not on the radar.
> 
> So make it an implementation statement. "However, not all
> implementations, such as some PowerPC ones, provide such an external
> timer ...".

Thanks for this information. I will update this going ahead.

Regards
Preeti U Murthy

