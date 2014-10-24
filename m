Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbaJXI52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 04:57:28 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:48032 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbaJXI5S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 04:57:18 -0400
X-AuditID: cbfee691-f79b86d000004a5a-3a-544a146b6d1e
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
 <54484993.1090803@lge.com>
In-reply-to: <54484993.1090803@lge.com>
Subject: RE: [PATCH v2 2/2] fs: proc: Include cma info in proc/meminfo
Date: Fri, 24 Oct 2014 14:27:09 +0530
Message-id: <018a01cfef68$88d0b450$9a721cf0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIYigTjXepmiJMFsP3pxyBCbUOBxwLhW73LAk7WH54A/Nn3DZt8UqFw
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfSzUcRzH+/5+33tgWT8X9UUqeqaUOH1bzdpq9VNrPWg1snT081Bct7tz
	q/yRQhvmPP5xjtmhIqnTec4KRylqs6FEhyLN8xCFVHd+2vz32mfvh89n+/BJQSvHlh8qljNS
	sSjMkWsOi6zcI3ddszp+bs+dhzY4S1vExX3D2RCrvsxBPKjfgXOrNQQeuPsD4Me6k/hRQjQX
	N/3+SOBP37MgrohT8XBS308ebn2excXdRX85+EmDgYfTxgYA1jTGcPCHF40knhnt4uGFNi3E
	9+4/I/D36FiI8xq6SJx5RwlwutIADtnQ9SPjJN2qTCRojS6C1k2m8uj40TaCfqOah3T22zN0
	r74E0k9/DxH0xLdOSI+/bOfSytJCQL/TNPDokuZIekq3ntaWlhGnLX3ND15hwkIVjHS352Xz
	kFJDFSnRbL8x0W8AUaB+Qzww4yPKHc3mz3NYXoNaurXceGDOF1APAKov6gL/RV+no7gmFlC5
	AE1Un2JF8wDFtvQbRXw+l9qGXtdamOZW1CCJFsYnCZOBpOQop0ALWUMbQM/f3F1MNTMaasoq
	Fnk1dRTFNhugiSG1Bf0sTlxkC2o/Ks+b5rFsiX6ldUM2dA8aVys5LDuj/rGWpRM2osr3w4uZ
	VsbM/rz5pSXWotTeLzxWU2KG2uvFbBeFZtL00HQAouyRrpZkJTaorqADJgOkXtasXtasXtas
	XtagAbAQWDOSQIksIFgqdJGJwmUR4mCXwOvhOmD8teY/AymVoKf2gB5QfOC40qJD5XVOwBEp
	ZDfD9UBo3CiFtLUOvG58T7Hc39XNYy8Wugvd9u7b7+G41mKn3ay3gAoWyZlrDCNhpP7SiDBG
	pgcE38w2CvgpPS9stR5KijshqfDKTpKvFARdVGR2No045Pv0HZNEJPgFXLpQ65IRMmt/G3/y
	FrtKdOlX4dSwfbR4xVTp2MIrh7MeGZ7nqzQ9xSGbCLvGDYed5pJzx3LKKxVxR/RhqfrDPnXr
	psiZzdW+ll0jqz43OQtvx3yM3XEruCbIT9Hx1RHKQkSuTqRUJvoHX2EOxmYDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA2WSf0yMYRzAPe/73t0bzt5O8YjSXsqvXbrq6olYw9rrRxOOmbG86l01d9ft
	3jvza3OkmrOOhOW0HLEpcZyQ31yNyI+Q37tWOiXkVoSpcN3JGs9fnz3PPp89z7MviUuKhQFk
	hlrHadWskhYOJmp/NlPStX7zFOGHKoeiImu5EDV/KCZQYdMPArXZJ6Ejly0Yatn2BaATtkRU
	ujNLiO72PMfQy9YiAl3YUShCu5q/idCTS0VC1FD+S4BOVjtEqOBTC0CW29sF6NnV2zj62v5a
	hHrrrQTKOXoGQ61Z2QQqqX6No4NbTQDtNTlA/Cim6qMLZ56Y8jDGYtMzts49IsbYXo8xNYXd
	BFN8ZxHTaD9LMKd63mNMx9tXBOO69lTImCrKAHPPUi1iztZuYj7bghhrxTksyXeFAcSlc2wq
	pw3m1CmZqRnqtBn0/CXJs5Pl0eEyqSwWxdDBalbFzaDnLEiSJmQo3X9CB69jlXr3VhLL8/TU
	mf8XlioSpKhfXC5NVCz+60SE/7NWl4P0CsdFXGOZuL7D6QAGUDXWCHxISEXBN10GoZdHwLoG
	q4cl1BEAOy4vNILBbu4GMLvOCYyAJIXUBHjrhrhv349qw2GvqxPrE3BKBw8ftxJeoR7ASzXb
	QN+Bj1u4fu6Ch4dTCTC71kH0MUGFwG+n8zwspmLh+ZIukZd94feCBsIbDYcus0ng5SnQ+alO
	4L1pMKy8/8HT9HM3nSXdfy4xEu5pbBLtBhLzgJR5QMo8IGUeoFgAUQb8OU2Khl+TpooI41kV
	r1enhaVkqmzAM5stoytBmQHZAUUCeqj4ReFchUTAruM3qOwAkjjtJ24k5ykk4lR2w0ZOm5ms
	1Ss53g7k7pfm4wH+KZnuSVfrkmWRUTHySHlsFIqKjqVHim9mT18kodJYHbeW4zSctt/DSJ8A
	A9icD6fnXl92bGX8irvtIQ875xa1RT7SNMXwIWHUlXfj6HH5lXGzePrZr5zAXOPjnxN8WqqH
	yHRdVZtDh+nTUwcFKSpcNaHDQ+Kk3Ji8OVuiP+9fJbU/0AfubS+L2Jcz/vzpYQXSrbp4/wBn
	VVbTtAPKvLqe96C1V2AqjQ99BR/5ymmCT2dlk3Etz/4GTAClzrEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

----- Original Message -----
> From: Gioh Kim <gioh.kim@lge.com>
> To: Pintu Kumar <pintu.k@samsung.com>; akpm@linux-foundation.org;
riel@redhat.com; aquini@redhat.com; paul.gortmaker@windriver.com;
jmarchan@redhat.com; lcapitulino@redhat.com;
kirill.shutemov@linux.intel.com; m.szyprowski@samsung.com;
aneesh.kumar@linux.vnet.ibm.com; iamjoonsoo.kim@lge.com; mina86@mina86.com;
lauraa@codeaurora.org; mgorman@suse.de; rientjes@google.com; hannes@cmpxchg.
org; vbabka@suse.cz; sasha.levin@oracle.com; linux-kernel@vger.kernel.org;
linux-mm@kvack.org
> Cc: pintu_agarwal@yahoo.com; cpgs@samsung.com; vishnu.ps@samsung.com;
rohit.kr@samsung.com; ed.savinay@samsung.com
> Sent: Thursday, 23 October 2014 5:49 AM
> Subject: Re: [PATCH v2 2/2] fs: proc: Include cma info in proc/meminfo
> 
> 
> 
> 2014-10-22 오후 11:06, Pintu Kumar 쓴 글:
>> This patch include CMA info (CMATotal, CMAFree) in /proc/meminfo.
>> Currently, in a CMA enabled system, if somebody wants to know the
>> total CMA size declared, there is no way to tell, other than the dmesg
>> or /var/log/messages logs.
>> With this patch we are showing the CMA info as part of meminfo, so that
>> it can be determined at any point of time.
>> This will be populated only when CMA is enabled.
>> 
>> Below is the sample output from a ARM based device with RAM:512MB and 
> CMA:16MB.
>> 
>> MemTotal:        471172 kB
>> MemFree:          111712 kB
>> MemAvailable:    271172 kB
>> .
>> .
>> .
>> CmaTotal:          16384 kB
>> CmaFree:            6144 kB
>> 
>> This patch also fix below checkpatch errors that were found during these 
> changes.
> 
> Why don't you split patch for it?
> I think there's a rule not to mix separate patchs.
> 

Last time when we submitted separate patches for checkpatch errors, it was
suggested to 
Include these kinds of fixes along with some meaningful patches together.
So, we included it in same patch.

>> 
>> ERROR: space required after that ',' (ctx:ExV)
>> 199: FILE: fs/proc/meminfo.c:199:
>> +      ,atomic_long_read(&num_poisoned_pages) << (PAGE_SHIFT - 
> 10)
>>           ^
>> 
>> ERROR: space required after that ',' (ctx:ExV)
>> 202: FILE: fs/proc/meminfo.c:202:
>> +      ,K(global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
>>           ^
>> 
>> ERROR: space required after that ',' (ctx:ExV)
>> 206: FILE: fs/proc/meminfo.c:206:
>> +      ,K(totalcma_pages)
>>           ^
>> 
>> total: 3 errors, 0 warnings, 2 checks, 236 lines checked
>> 
>> Signed-off-by: Pintu Kumar <pintu.k@samsung.com>
>> Signed-off-by: Vishnu Pratap Singh <vishnu.ps@samsung.com>
>> ---
>>   fs/proc/meminfo.c |  15 +++++++++++++--
>>   1 file changed, 13 insertions(+), 2 deletions(-)
>> 
>> diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
>> index aa1eee0..d3ebf2e 100644
>> --- a/fs/proc/meminfo.c
>> +++ b/fs/proc/meminfo.c
>> @@ -12,6 +12,9 @@
>>   #include <linux/vmstat.h>
>>   #include <linux/atomic.h>
>>   #include <linux/vmalloc.h>
>> +#ifdef CONFIG_CMA
>> +#include <linux/cma.h>
>> +#endif
>>   #include <asm/page.h>
>>   #include <asm/pgtable.h>
>>   #include "internal.h"
>> @@ -138,6 +141,10 @@ static int meminfo_proc_show(struct seq_file *m,
void 
> *v)
>>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>           "AnonHugePages:  %8lu kB\n"
>>   #endif
>> +#ifdef CONFIG_CMA
>> +        "CmaTotal:      %8lu kB\n"
>> +        "CmaFree:        %8lu kB\n"
>> +#endif
>>           ,
>>           K(i.totalram),
>>           K(i.freeram),
>> @@ -187,12 +194,16 @@ static int meminfo_proc_show(struct seq_file *m,
void 
> *v)
>>           vmi.used >> 10,
>>           vmi.largest_chunk >> 10
>>   #ifdef CONFIG_MEMORY_FAILURE
>> -        ,atomic_long_read(&num_poisoned_pages) << (PAGE_SHIFT - 
> 10)
>> +        , atomic_long_read(&num_poisoned_pages) << (PAGE_SHIFT - 
> 10)
>>   #endif
>>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> -        ,K(global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
>> +        , K(global_page_state(NR_ANON_TRANSPARENT_HUGEPAGES) *
>>             HPAGE_PMD_NR)
>>   #endif
>> +#ifdef CONFIG_CMA
>> +        , K(totalcma_pages)
>> +        , K(global_page_state(NR_FREE_CMA_PAGES))
>> +#endif
>>           );
> 
> Just for sure, are zoneinfo and pagetypeinfo not suitable?
> 

I think zoneinfo shows only current free cma pages.
Same is the case with vmstat.
# cat /proc/zoneinfo | grep cma
    nr_free_cma  2560
# cat /proc/vmstat | grep cma
nr_free_cma 2560

> I don't know HOTPLUG feature so I'm just asking for sure.
> Does HOTPLUG not need printing message like this?
> 

Sorry, I am also not sure what hotplug feature you are referring to.

> Thanks a lot.
> 
> 
>>   
>>       hugetlb_report_meminfo(m);
>> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> 
> email@kvack.org </a>
>

