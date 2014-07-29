Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213AbaG2Jr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:47:57 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:35970 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbaG2Jr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:47:56 -0400
Message-ID: <53D76DBD.9080403@huawei.com>
Date: Tue, 29 Jul 2014 17:47:41 +0800
From: Zhang Zhen <zhenzhang.zhang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Dave Hansen <dave.hansen@intel.com>, <mgorman@suse.de>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, <wangnan0@huawei.com>,
        Linux MM <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] memory hotplug: update the variables after memory
 removed
References: <1406619310-20555-1-git-send-email-zhenzhang.zhang@huawei.com> <53D74EE5.1070308@huawei.com> <alpine.DEB.2.02.1407290046470.7998@chino.kir.corp.google.com> <53D75E13.8000702@huawei.com> <alpine.DEB.2.02.1407290216520.13227@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1407290216520.13227@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.69.77]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020201.53D76DC9.011E,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 20d01a034e1369a02210e2d476771ae7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/7/29 17:18, David Rientjes wrote:
> On Tue, 29 Jul 2014, Zhang Zhen wrote:
> 
>>>> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
>>>> index df1a992..fd7bd6b 100644
>>>> --- a/arch/x86/mm/init_64.c
>>>> +++ b/arch/x86/mm/init_64.c
>>>> @@ -673,15 +673,11 @@ void __init paging_init(void)
>>>>   * After memory hotplug the variables max_pfn, max_low_pfn and high_memory need
>>>>   * updating.
>>>>   */
>>>> -static void  update_end_of_memory_vars(u64 start, u64 size)
>>>> +static void  update_end_of_memory_vars(u64 end_pfn)
>>>
>>> Extra space that can be removed here at the same time as a cleanup.
>>>
>> Sorry, where is the extra space here?
>>
> 
> There are two spaces between the function identifier and the function 
> type whereas there is traditionally only one.  It existed before your 
> patch, it would just be nice to clean it up since you're already touching 
> the line.
> 
Ok. Thanks.
> 


