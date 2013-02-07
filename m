Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595Ab3BGGNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 01:13:44 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:46291 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab3BGGNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 01:13:41 -0500
Message-ID: <51134596.4080106@linux.vnet.ibm.com>
Date: Thu, 07 Feb 2013 11:41:34 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, mingo@kernel.org,
        linux-arch@vger.kernel.org, linux@arm.linux.org.uk,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        fweisbec@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        xiaoguangrong@linux.vnet.ibm.com, rjw@sisk.pl, sbw@mit.edu,
        wangyun@linux.vnet.ibm.com, netdev@vger.kernel.org,
        namhyung@kernel.org, akpm@linux-foundation.org, walken@google.com,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 00/45] CPU hotplug: stop_machine()-free CPU hotplug
References: <20130122073210.13822.50434.stgit@srivatsabhat.in.ibm.com> <510FBC01.2030405@linux.vnet.ibm.com> <87haloiwv0.fsf@rustcorp.com.au>
In-Reply-To: <87haloiwv0.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020706-8878-0000-0000-000005CF9FC7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 09:44 AM, Rusty Russell wrote:
> "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> writes:
>> On 01/22/2013 01:03 PM, Srivatsa S. Bhat wrote:
>>                  Avg. latency of 1 CPU offline (ms) [stop-cpu/stop-m/c latency]
>>
>> # online CPUs    Mainline (with stop-m/c)       This patchset (no stop-m/c)
>>
>>       8                 17.04                          7.73
>>
>>      16                 18.05                          6.44
>>
>>      32                 17.31                          7.39
>>
>>      64                 32.40                          9.28
>>
>>     128                 98.23                          7.35
> 
> Nice!

Thank you :-)

>  I wonder how the ARM guys feel with their quad-cpu systems...
> 

That would be definitely interesting to know :-)

Regards,
Srivatsa S. Bhat

