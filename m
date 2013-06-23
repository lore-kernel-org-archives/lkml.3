Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab3FWTAK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 15:00:10 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:55263 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab3FWTAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 15:00:04 -0400
Message-ID: <51C744E6.1040905@linux.vnet.ibm.com>
Date: Mon, 24 Jun 2013 00:26:38 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Matt Turner <mattst88@gmail.com>
CC: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, walken@google.com,
        vincent.guittot@linaro.org, laijs@cn.fujitsu.com, rostedt@goodmis.org,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        sbw@mit.edu, fweisbec@gmail.com, zhong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        linux-alpha@vger.kernel.org
Subject: Re: [PATCH 31/45] alpha/smp: Use get/put_online_cpus_atomic() to
 prevent CPU offline
References: <20130623133642.19094.16038.stgit@srivatsabhat.in.ibm.com> <20130623134516.19094.57189.stgit@srivatsabhat.in.ibm.com> <CAEdQ38HLzNoRABCUR7tEoBLJWn86xSd2VfSHxs0MPj5r5GvTXQ@mail.gmail.com>
In-Reply-To: <CAEdQ38HLzNoRABCUR7tEoBLJWn86xSd2VfSHxs0MPj5r5GvTXQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062318-1618-0000-0000-0000042229C3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2013 11:20 PM, Matt Turner wrote:
> On Sun, Jun 23, 2013 at 6:45 AM, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> Once stop_machine() is gone from the CPU offline path, we won't be able
>> to depend on disabling preemption to prevent CPUs from going offline
>> from under us.
>>
>> Use the get/put_online_cpus_atomic() APIs to prevent CPUs from going
>> offline, while invoking from atomic context.
>>
>> Also, remove the non-ASCII character present in this file!
> 
> It's not non-ASCII. It's a page break.
> 

Oh, ok..

Regards,
Srivatsa S. Bhat

