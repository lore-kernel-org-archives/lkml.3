Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817AbaBDRSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 12:18:31 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:50213 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbaBDRS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 12:18:29 -0500
Message-ID: <52F12008.4040103@linux.vnet.ibm.com>
Date: Tue, 04 Feb 2014 22:44:48 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: daniel.lezcano@linaro.org, peterz@infradead.org, fweisbec@gmail.com,
        galak@kernel.crashing.org, paul.gortmaker@windriver.com,
        paulus@samba.org, mingo@kernel.org, mikey@neuling.org,
        shangw@linux.vnet.ibm.com, rafael.j.wysocki@intel.com, agraf@suse.de,
        benh@kernel.crashing.org, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, michael@ellerman.id.au,
        john.stultz@linaro.org, anton@samba.org, chenhui.zhao@freescale.com,
        deepthi@linux.vnet.ibm.com, r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH V2 1/2] time: Change the return type of clockevents_notify()
 to integer
References: <20140124065501.17564.39363.stgit@preeti.in.ibm.com> <20140124065739.17564.97259.stgit@preeti.in.ibm.com> <alpine.DEB.2.02.1402041100250.24986@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1402041100250.24986@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020417-3864-0000-0000-00000C41EFCB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04/2014 03:31 PM, Thomas Gleixner wrote:
> On Fri, 24 Jan 2014, Preeti U Murthy wrote:
>> -extern void tick_broadcast_oneshot_control(unsigned long reason);
>> +extern int tick_broadcast_oneshot_control(unsigned long reason);
> 
>> -static inline void tick_broadcast_oneshot_control(unsigned long reason) { }
>> +static inline int tick_broadcast_oneshot_control(unsigned long reason) { }
> 
>> -static inline void tick_broadcast_oneshot_control(unsigned long reason) { }
>> +static inline int tick_broadcast_oneshot_control(unsigned long reason) { }
> 
> The inline stubs need to return 0.

Oh right! Apologies!
Thanks.
> 
> Thanks,
> 
> 	tglx
> 

Regards
Preeti U Murthy

