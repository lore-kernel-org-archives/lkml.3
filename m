Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab3D0IUy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 04:20:54 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:43064 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175Ab3D0IUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 04:20:51 -0400
Message-ID: <517B8A5D.1030308@gmail.com>
Date: Sat, 27 Apr 2013 16:20:45 +0800
From: Will Huck <will.huckk@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Han Pingtian <hanpt@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, mhocko@suse.cz,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org
Subject: Re: OOM-killer and strange RSS value in 3.9-rc7
References: <alpine.DEB.2.02.1304161315290.30779@chino.kir.corp.google.com> <20130417094750.GB2672@localhost.localdomain> <20130417141909.GA24912@dhcp22.suse.cz> <20130418101541.GC2672@localhost.localdomain> <20130418175513.GA12581@dhcp22.suse.cz> <20130423131558.GH8001@dhcp22.suse.cz> <20130424044848.GI2672@localhost.localdomain> <20130424094732.GB31960@dhcp22.suse.cz> <0000013e3cb0340d-00f360e3-076b-478e-b94c-ddd4476196ce-000000@email.amazonses.com> <20130425060705.GK2672@localhost.localdomain> <0000013e42332267-0b7fb3c0-9150-4058-8850-ae094b455b15-000000@email.amazonses.com>
In-Reply-To: <0000013e42332267-0b7fb3c0-9150-4058-8850-ae094b455b15-000000@email.amazonses.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,
On 04/26/2013 01:17 AM, Christoph Lameter wrote:
> On Thu, 25 Apr 2013, Han Pingtian wrote:
>
>> I have enabled "slub_debug" and here is the
>> /sys/kernel/slab/kmalloc-512/alloc_calls contents:
>>
>>       50 .__alloc_workqueue_key+0x90/0x5d0 age=113630/116957/119419 pid=1-1730 cpus=0,6-8,13,24,26,44,53,57,60,68 nodes=1
>>       11 .__alloc_workqueue_key+0x16c/0x5d0 age=113814/116733/119419 pid=1-1730 cpus=0,44,68 nodes=1
>>       13 .add_sysfs_param.isra.2+0x80/0x210 age=115175/117994/118779 pid=1-1342 cpus=0,8,12,24,60 nodes=1
>>      160 .build_sched_domains+0x108/0xe30 age=119111/119120/119131 pid=1 cpus=0 nodes=1
>>     9000 .alloc_fair_sched_group+0xe4/0x220 age=110549/114471/117357 pid=1-2290 cpus=0-1,5,9-11,13,24,29,33,36,38,40-41,45,48-50,53,56-58,60-63,68-69,72-73,76-77,79 nodes=1
>>     9000 .alloc_fair_sched_group+0x114/0x220 age=110549/114471/117357 pid=1-2290 cpus=0-1,5,9-11,13,24,29,33,36,38,40-41,45,48-50,53,56-58,60-63,68-69,72-73,76-77,79 nodes=1

Could you explain the meaning of  age=xx/xx/xx  pid=xx-xx cpus=xx here?

> ?? Is that normal to have that amount of sched group allocations?
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

