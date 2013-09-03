Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904Ab3ICKtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 06:49:04 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:34433 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab3ICKtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 06:49:02 -0400
Message-ID: <5225BE3A.3090602@linux.vnet.ibm.com>
Date: Tue, 03 Sep 2013 16:17:22 +0530
From: Janani Venkataraman <jananive@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Pavel Emelyanov <xemul@parallels.com>
CC: linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>,
        Roland McGrath <roland@hack.frob.com>,
        Amerigo Wang <amwang@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>, avagin@openvz.org, gorcunov@openvz.org,
        James Hogan <james.hogan@imgtec.com>,
        Mike Frysinger <vapier@gentoo.org>,
        "Randy.Dunlap" <rdunlap@xenotime.net>, Eric Paris <eparis@redhat.com>,
        ananth@in.ibm.com, suzuki@in.ibm.com, aravinda@linux.vnet.ibm.com,
        tarundeep.singh@in.ibm.com
Subject: Re: RFD: Non-Disruptive Core Dump Infrastructure
References: <522472DA.4000702@linux.vnet.ibm.com> <5225A02B.6080901@linux.vnet.ibm.com> <5225BA91.6080904@parallels.com>
In-Reply-To: <5225BA91.6080904@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090310-8256-0000-0000-000009106851
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 04:01 PM, Pavel Emelyanov wrote:
> On 09/03/2013 12:39 PM, Janani Venkataraman wrote:
>> Hello,
>>
>> We are working on an infrastructure to create a system core file of a specific
>> process at run-time, non-disruptively. It can also be extended to a case where
>> a process is able to take a self-core dump.
>
> This is very close to what we're trying to do in CRIU. And although image files
> containing info about processes are not ELF files, an ability to generate ELF-cores
> out of existing CRIU images is one of the features that we were asked for.
>
>> 2) CRIU Approach :
>>
>> This makes use of the CRIU tool and checkpoints when a dump is called, collects
>> the required details and continues the running process.
>> * A self dump cannot be initiated using the command line CRIU which is similar
>> to the limitation of gcore.
>
> This is something we're trying to fix at the moment, as people ask for 'self-dump'
> ability as well. We plan to have this implemented in v0.8 (the v0.7 is coming out
> today/tomorrow) in about a month.
>
> I can shed more light on this, if required.
>
>> * A system call to do the same is being implemented which would help us create
>> a self dump.The system call is not upstream yet. We could explore that option as
>> well.
>
> Thanks,
> Pavel
>
Hi,

I would like to know more about the "self-dump" ability of CRIU. This is 
the implementation using system calls if I am not wrong.

Thanking You.
Regards,
Janani Venkataraman

