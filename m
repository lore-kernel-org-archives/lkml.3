Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761109Ab3BJTg0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 14:36:26 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:52453 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab3BJTgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 14:36:23 -0500
Message-ID: <5117F638.9070700@linux.vnet.ibm.com>
Date: Mon, 11 Feb 2013 01:04:16 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: linux-doc@vger.kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org,
        linux-arch@vger.kernel.org, linux@arm.linux.org.uk,
        xiaoguangrong@linux.vnet.ibm.com, wangyun@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, rusty@rustcorp.com.au, rostedt@goodmis.org,
        rjw@sisk.pl, tglx@linutronix.de, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, oleg@redhat.com, sbw@mit.edu, tj@kernel.org,
        akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v5 07/45] CPU hotplug: Provide APIs to prevent CPU offline
 from atomic context
References: <20130122073210.13822.50434.stgit@srivatsabhat.in.ibm.com> <20130122073446.13822.39253.stgit@srivatsabhat.in.ibm.com> <87mwvsuw68.fsf@sejong.aot.lge.com>
In-Reply-To: <87mwvsuw68.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021019-0260-0000-0000-00000282B3A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Namhyung,

On 01/29/2013 03:51 PM, Namhyung Kim wrote:
> Hi Srivatsa,
> 
> On Tue, 22 Jan 2013 13:04:54 +0530, Srivatsa S. Bhat wrote:
>> @@ -246,15 +291,21 @@ struct take_cpu_down_param {
>>  static int __ref take_cpu_down(void *_param)
>>  {
>>  	struct take_cpu_down_param *param = _param;
>> -	int err;
>> +	unsigned long flags;
>> +	int err = 0;
> 
> It seems no need to set 'err' to 0.
>

Sorry for the late reply. This mail got buried in my inbox and
I hadn't noticed it until now.. :-(

I'll remove the unnecessary initialization. Thank you!

Regards,
Srivatsa S. Bhat

