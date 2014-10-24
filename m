Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338AbaJXKnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:43:37 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:54601 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066AbaJXKnd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:43:33 -0400
X-AuditID: cbfee68d-f79296d000004278-24-544a2d5379b6
From: PINTU KUMAR <pintu.k@samsung.com>
To: "'Gioh Kim'" <gioh.kim@lge.com>, akpm@linux-foundation.org,
        riel@redhat.com, aquini@redhat.com, paul.gortmaker@windriver.com,
        jmarchan@redhat.com, lcapitulino@redhat.com,
        kirill.shutemov@linux.intel.com, m.szyprowski@samsung.com,
        aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com,
        mina86@mina86.com, lauraa@codeaurora.org, mgorman@suse.de,
        rientjes@google.com, hannes@cmpxchg.org, vbabka@suse.cz,
        sasha.levin@oracle.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: pintu_agarwal@yahoo.com, cpgs@samsung.com, vishnu.ps@samsung.com,
        rohit.kr@samsung.com, ed.savinay@samsung.com
References: <1413790391-31686-1-git-send-email-pintu.k@samsung.com>
 <1413986796-19732-1-git-send-email-pintu.k@samsung.com>
 <1413986796-19732-2-git-send-email-pintu.k@samsung.com>
 <54484993.1090803@lge.com> <018a01cfef68$88d0b450$9a721cf0$@samsung.com>
 <544A2588.40802@lge.com>
In-reply-to: <544A2588.40802@lge.com>
Subject: RE: [PATCH v2 2/2] fs: proc: Include cma info in proc/meminfo
Date: Fri, 24 Oct 2014 16:13:38 +0530
Message-id: <019701cfef77$60ec7690$22c563b0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIYigTjXepmiJMFsP3pxyBCbUOBxwLhW73LAk7WH54A/Nn3DQJANmtJAVk9QlWbX6Md8A==
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA02SWUwTURSGvTO3M6WhcaggV4yKjRsSF1YvkRjigxlMjCg+qLhVnCDK0rTF
	fUERjRgKCMZaEAoqoKLVgkJAtFYiCIIkLCKEClFBoFC3IIuIraMJb99Z//8kR0hKWgRuwsgY
	FaeIkUVJKREscvY9uSx02fotK/XtCGfpiyj8YSAbYk33GMR9Jg+cV6EjcM/ZHwDfNWzAty8l
	ULj211sCv+vNgrj0oobGKR9+0ripPIvC5qJJAb5X1Unj9KEegHXV5wS4tbKaxMODHTSeaNZD
	fP7mQwL3JiRCfKOqg8SZZ9QAZ6g7QdAs9oXFSrJN6mSC1RniWMO3yzSbNNhMsDWacchmv9rE
	dpmKIXv/Vz/Bfv3UDlnr0xaKVZfcAexrXRXNFtcdZ78b5rL6kkdEiNN2UeA+LiryEKdYsWaP
	aH9RXhct1wQd+ZkySsWDIe8k4CBEjC/KmHxA8DwTNZr1VBIQCSXMLYASjRbif9Oz3g7AF64C
	lPP5FsEH4wBVVDbYAqGQYhajl0axPe/M9JFowvrt7zTJqFBuoR7yA9cJlPu+kbYXHJiFKL57
	krTzDGYdSqzrhHaGtvzYFT4vZgJQ9kgyxbMTGkk3Q37pSmTVqgU8e6KPQ40C3qo7KqsfAHZ2
	Zrai/Ob4f/2u6HJXN203gZhSB1RrKQC8GIOG003QfgFi5iCDkeT3zELPC9tgKkDaKdLaKdLa
	KdLaKRI6AO8AF04eLlfujVB4LVfKopVxMRHLw2OjDcD2bXW/e5LLQIdxtQkwQiB1FLdpgrdI
	BLJDyqPRJuBnc5RGurmEx9oeNEa128vH3xv7+fr5eK8K8Je6iue7jYZKmAiZijvIcXJOsVsR
	F8UpTYAQOrjFgwD3s7mt9eufHKh5cXDbjnzZjozTEzmqvr6GG2CJfPqVyecpB6Ztrsk+NdCQ
	iYYL2y09QWb/2RdeLZLGtlQa14rSSrkvpoKNwc5krTXwcbRk14mwOtkCrm3oWKLRk/pM9B8W
	l1+T35230+j4NDS3eW7QpXzzm7bxltSm9HyPsBDLVilU7pd5LSUVStkfV65uAGgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPJsWRmVeSWpSXmKPExsVy+t9jQd1gXa8Qg9u/uSzmrF/DZvH49TwW
	ixkPf7FYvDykabFo9wImi2dNXxgtVm/ytVjZ3cxmcerPdSaLm8/nsFhs75zBbtH/+Du7xeVd
	c9gs7q35z2qx9shddovJ754xWiw43sJqcW3vcWaLb29vs1v8vbKexaJtyUYmi+fNrSwWi4/c
	ZraY3djHaDGl7y6jg6TH4TfvmT0u9/UyeSzYVOqx6dMkdo+ut1eYPE7M+M3iMe9koMeDQ5tZ
	PNb9ecXk8fHpLRaP9/uusnn0bVnF6HFmwRF2j82nqz0+b5LzWL9lK1OAYFQDo01GamJKapFC
	al5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YOMEyUFMoSc0qBQgGJxcVK
	+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBlrFj1gL5jhUPG9/ydbA+M7oy5GTg4JAROJ/c9v
	M0LYYhIX7q1n62Lk4hASmM4oMf/FUiYI5zejxO6954AcDg42AXWJYwd4QeIiAi+ZJf6+/8QE
	0s0sUCKxcMV6FoiGuUwSC+9fYAdJcAqoSjQ8/M8MYgsLuEm0nr7LAmKzAMV/TYWI8wpYSsz7
	0csGYQtK/Jh8jwViqIHE+1l9rBC2tsSTdxdYIU5VkNhx9jXY2SICERLLrjRA1YtLTHrwkH0C
	o9AsJKNmIRk1C8moWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQITpzPpHcwrmqw
	OMQowMGoxMN7Y4ZniBBrYllxZe4hRgkOZiUR3pdqXiFCvCmJlVWpRfnxRaU5qcWHGE2BPp3I
	LCWanA9M6nkl8YbGJuamxqaWJhYmZpZK4rwHW60DhQTSE0tSs1NTC1KLYPqYODilGhgXTrQ8
	vOLBk5D5Fv79CpP5L+qo/Ok9YK8ce7fzplesxllBBjOBaJkTf+eZufupfONbYpFobzz3cPqf
	dMkm549zN5pvrt6j8iU+PimqdvMjcbWD/vZfnTbx6YjwdfZ82tC1SuyC2/U782IdfywQulHi
	0vuRt65HXEjf5InPu8sFMkaXRLS95yqxFGckGmoxFxUnAgB/pZxpsgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: Gioh Kim <gioh.kim@lge.com>
> To: PINTU KUMAR <pintu.k@samsung.com>; akpm@linux-foundation.org;
riel@redhat.com; aquini@redhat.com; paul.gortmaker@windriver.com;
jmarchan@redhat.com; lcapitulino@redhat.com;
kirill.shutemov@linux.intel.com; m.szyprowski@samsung.com;
aneesh.kumar@linux.vnet.ibm.com; iamjoonsoo.kim@lge.com; mina86@mina86.com;
lauraa@codeaurora.org; mgorman@suse.de; rientjes@google.com; hannes@cmpxchg.
org; vbabka@suse.cz; sasha.levin@oracle.com; linux-kernel@vger.kernel.org;
linux-mm@kvack.org
> Cc: pintu_agarwal@yahoo.com; cpgs@samsung.com; vishnu.ps@samsung.com;
rohit.kr@samsung.com; ed.savinay@samsung.com
> Sent: Friday, 24 October 2014 3:40 PM
> Subject: Re: [PATCH v2 2/2] fs: proc: Include cma info in proc/meminfo
> 
> 
> 
> 2014-10-24 오후 5:57, PINTU KUMAR 쓴 글:
>> Hi,
>> 
>> ----- Original Message -----
>>> From: Gioh Kim <gioh.kim@lge.com>
>>> To: Pintu Kumar <pintu.k@samsung.com>; akpm@linux-foundation.org;
>> riel@redhat.com; aquini@redhat.com; paul.gortmaker@windriver.com;
>> jmarchan@redhat.com; lcapitulino@redhat.com;
>> kirill.shutemov@linux.intel.com; m.szyprowski@samsung.com;
>> aneesh.kumar@linux.vnet.ibm.com; iamjoonsoo.kim@lge.com;
mina86@mina86.com;
>> lauraa@codeaurora.org; mgorman@suse.de; rientjes@google.com; 
> hannes@cmpxchg.
>> org; vbabka@suse.cz; sasha.levin@oracle.com; linux-
kernel@vger.kernel.org;
>> linux-mm@kvack.org
>>> Cc: pintu_agarwal@yahoo.com; cpgs@samsung.com; vishnu.ps@samsung.com;
>> rohit.kr@samsung.com; ed.savinay@samsung.com
>>> Sent: Thursday, 23 October 2014 5:49 AM
>>> Subject: Re: [PATCH v2 2/2] fs: proc: Include cma info in proc/meminfo
>>> 
>>> 
>>> 
>>> 2014-10-22 오후 11:06, Pintu Kumar 쓴 글:
>>>> This patch include CMA info (CMATotal, CMAFree) in /proc/meminfo.
>>>> Currently, in a CMA enabled system, if somebody wants to know the
>>>> total CMA size declared, there is no way to tell, other than the 
> dmesg
>>>> or /var/log/messages logs.
>>>> With this patch we are showing the CMA info as part of meminfo, so 
> that
>>>> it can be determined at any point of time.
>>>> This will be populated only when CMA is enabled.
>>>> 
>>>> Below is the sample output from a ARM based device with RAM:512MB 
> and
>>> CMA:16MB.
>>>> 
>>>> MemTotal:        471172 kB
>>>> MemFree:          111712 kB
>>>> MemAvailable:    271172 kB
>>>> .
>>>> .
>>>> .
>>>> CmaTotal:          16384 kB
>>>> CmaFree:            6144 kB
>>>> 
>>>> This patch also fix below checkpatch errors that were found during 
> these
>>> changes.
>>> 
>>> Why don't you split patch for it?
>>> I think there's a rule not to mix separate patchs.
>>> 
>> 
>> Last time when we submitted separate patches for checkpatch errors, it
was
>> suggested to
>> Include these kinds of fixes along with some meaningful patches together.
>> So, we included it in same patch.
>> 
>>>> 
>>>> ERROR: space required after that ',' (ctx:ExV)
>>>> 199: FILE: fs/proc/meminfo.c:199:
>>>> +      ,atomic_long_read(&num_poisoned_pages) << 
> (PAGE_SHIFT -
>>> 10)
>>>>             ^
>>>> 
>>>> ERROR: space required after that ',' (ctx:ExV)
>>>> 202: FILE: fs/proc/meminfo.c:202:
>>>> +      ,K(global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
>>>>             ^
>>>> 
>>>> ERROR: space required after that ',' (ctx:ExV)
>>>> 206: FILE: fs/proc/meminfo.c:206:
>>>> +      ,K(totalcma_pages)
>>>>             ^
>>>> 
>>>> total: 3 errors, 0 warnings, 2 checks, 236 lines checked
>>>> 
>>>> Signed-off-by: Pintu Kumar <pintu.k@samsung.com>
>>>> Signed-off-by: Vishnu Pratap Singh <vishnu.ps@samsung.com>
>>>> ---
>>>>     fs/proc/meminfo.c |  15 +++++++++++++--
>>>>     1 file changed, 13 insertions(+), 2 deletions(-)
>>>> 
>>>> diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
>>>> index aa1eee0..d3ebf2e 100644
>>>> --- a/fs/proc/meminfo.c
>>>> +++ b/fs/proc/meminfo.c
>>>> @@ -12,6 +12,9 @@
>>>>     #include <linux/vmstat.h>
>>>>     #include <linux/atomic.h>
>>>>     #include <linux/vmalloc.h>
>>>> +#ifdef CONFIG_CMA
>>>> +#include <linux/cma.h>
>>>> +#endif
>>>>     #include <asm/page.h>
>>>>     #include <asm/pgtable.h>
>>>>     #include "internal.h"
>>>> @@ -138,6 +141,10 @@ static int meminfo_proc_show(struct seq_file 
> *m,
>> void
>>> *v)
>>>>     #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>>>             "AnonHugePages:  %8lu kB\n"
>>>>     #endif
>>>> +#ifdef CONFIG_CMA
>>>> +        "CmaTotal:      %8lu kB\n"
>>>> +        "CmaFree:        %8lu kB\n"
>>>> +#endif
>>>>             ,
>>>>             K(i.totalram),
>>>>             K(i.freeram),
>>>> @@ -187,12 +194,16 @@ static int meminfo_proc_show(struct seq_file 
> *m,
>> void
>>> *v)
>>>>             vmi.used >> 10,
>>>>             vmi.largest_chunk >> 10
>>>>     #ifdef CONFIG_MEMORY_FAILURE
>>>> -        ,atomic_long_read(&num_poisoned_pages) << 
> (PAGE_SHIFT -
>>> 10)
>>>> +        , atomic_long_read(&num_poisoned_pages) << 
> (PAGE_SHIFT -
>>> 10)
>>>>     #endif
>>>>     #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>>> -        ,K(global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
>>>> +        , K(global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
>>>>               HPAGE_PMD_NR)
>>>>     #endif
>>>> +#ifdef CONFIG_CMA
>>>> +        , K(totalcma_pages)
>>>> +        , K(global_page_state(NR_FREE_CMA_PAGES))
>>>> +#endif
>>>>             );
>>> 
>>> Just for sure, are zoneinfo and pagetypeinfo not suitable?
>>> 
>> 
>> I think zoneinfo shows only current free cma pages.
>> Same is the case with vmstat.
>> # cat /proc/zoneinfo | grep cma
>>       nr_free_cma  2560
>> # cat /proc/vmstat | grep cma
>> nr_free_cma 2560
> 
> We could add a line to show total cma pages like following and add it all.
> # cat /proc/zoneinfo | grep cma
>       nr_total_cma XXXX
>       nr_free_cma  2560
> 
> Yes. each zone can have cma area and it is annoying to add it all.
> But IMO it is rare and not difficult.
> And I think it'd better that zoneinfo has nr_total_cma line.
> 
> I think you already considered my thoughts and choosed /proc/meminfo for
a 
> certain reason.
> Why is /proc/meminfo better?
> 
We already had a plan to include CMA info in meminfo, but first we wanted
to have totalcma_pages available.
So, we developed it as second patch, if first is accepted.
We have chosen meminfo, because, we thought it's better to capture all
information at one place.
We have a tool where we capture free/cached/swap memory info, along with
CMA info.
So, reading from single proc entry it is better.
And I am sure there will be many other user space tool like that, and it
will be easy to integrate CMA info to them.
For example; we can integrate CMA info in "free" command, if required.

Also, when we saw /proc/meminfo, we saw that other similar fields are also
present here.
Such as;
SwapTotal:             0 kB
SwapFree:              0 kB
VmallocTotal:     499712 kB
VmallocUsed:       31576 kB

> Andrew already accepted it. I'm not against your idea. Just curious.
> 
>> 
>>> I don't know HOTPLUG feature so I'm just asking for sure.
>>> Does HOTPLUG not need printing message like this?
>>> 
>> 
>> Sorry, I am also not sure what hotplug feature you are referring to.
> 
> I mean "memory hotplug" feature.
> Forget it ;-)
> 
>> 
>>> Thanks a lot.
>>> 
>>> 
>>>>     
>>>>         hugetlb_report_meminfo(m);
>>>> 
>>> 
>>> --
>>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>>> the body to majordomo@kvack.org.  For more info on Linux MM,
>>> see: http://www.linux-mm.org/ .
>>> Don't email: <a href=mailto:"dont@kvack.org">
>>> email@kvack.org </a>
> 
>>> 
>> 
>> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> 
> email@kvack.org </a>
>

