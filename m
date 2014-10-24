Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040AbaJXKaf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 06:30:35 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:10263 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbaJXKad convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:30:33 -0400
X-AuditID: cbfee68e-f79b46d000002b74-7a-544a2a46e89b
From: PINTU KUMAR <pintu.k@samsung.com>
To: "'Michal Nazarewicz'" <mina86@mina86.com>, akpm@linux-foundation.org,
        riel@redhat.com, aquini@redhat.com, paul.gortmaker@windriver.com,
        jmarchan@redhat.com, lcapitulino@redhat.com,
        kirill.shutemov@linux.intel.com, m.szyprowski@samsung.com,
        aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com,
        lauraa@codeaurora.org, gioh.kim@lge.com, mgorman@suse.de,
        rientjes@google.com, hannes@cmpxchg.org, vbabka@suse.cz,
        sasha.levin@oracle.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Cc: pintu_agarwal@yahoo.com, cpgs@samsung.com, vishnu.ps@samsung.com,
        rohit.kr@samsung.com, ed.savinay@samsung.com
References: <1413790391-31686-1-git-send-email-pintu.k@samsung.com>
 <1413986796-19732-1-git-send-email-pintu.k@samsung.com>
 <xa1tegtylnzl.fsf@mina86.com>
In-reply-to: <xa1tegtylnzl.fsf@mina86.com>
Subject: RE: [PATCH v2 1/2] mm: cma: split cma-reserved in dmesg log
Date: Fri, 24 Oct 2014 16:00:27 +0530
Message-id: <019601cfef75$8fbf8860$af3e9920$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIYigTjXepmiJMFsP3pxyBCbUOBxwLhW73LAmj2Zfibg2qOEA==
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA01SbUhTYRTuvfdudw5HV5v6OirCMsnK8rM3iqiIugWSlVFEZctuK9Jpu04s
	/1jTIqX5MYOxpk5TM9OGM2slhV0tzZKEac2G5kcq5hdZaKVmzkvgv+ec8zzneQ4cEe7eLpCJ
	LioTGJVSHuMjFBMV0pDkjXv9D0RutjoCkdFcIUR9w/kE0vf8IdAQtw4V1ZowNHD9J0APLeHo
	QYZGiJpnPmGoY9BIoKe39CTK7Jsike25UYi6KuYEqLKhk0S6sQGATI2pAvTxRSOOJkcdJJpt
	MxPoRnEVhgY1aQS61+DA0d1rWoBytZ1gpzddPzKO0zbtbYw2WdS0ZSKHpNNH2zC6ST9N0Plv
	D9HdXDVBP5r5htHf+z8T9PjLdiGtfVwO6PemBpKufpdM/7CspM2Pa7AItxPi7eeYmIuJjGrT
	jjPiCw0pb7F4c0BS1YtqkAI+rkkHLiJIhcDWu0Ukjz1ha5dZmA7EIneqBECH/q/wP6m2xIDx
	gyIAs2bbBHwxDWDLlHFeLhIJKT/4pk7i7EupCRwacu8sqHEqARaWmQlekAfgaHkxcA5cKH/Y
	WfMKd+Jl1B7YNPEEc2KC8oW/CmYXOBJqK8wyZ+A8doO/dF0Ev9QP5uQX4TxeD7+OtQr4qKug
	tWV4QSuldsPe7DyM53jBnO4e0hkCUrUu0DGpIXkzCk7qOMJ5AaRWQEsdzu/xhq/K7EQWgIZF
	1oZF1oZF1oZFFiZAlAMPJj46nj2rUAUFsPJYVq1UBETHxVrA/Le9+zugtYKOum0coETAx1Vi
	1++PdBfIE9krsRwInU+Ujcs8ouPmH1SZEBUYHBaEQkNCg4O2bA3z8ZKckf0+4k4p5AnMJYaJ
	Z1RRKnUMw3IAE7nIUkCmssKzmVtTKX4mb1qrirlenm0U9KlPT7/OzJNfauYu2ySrq9J8d1V+
	qJ9eVZNdH3fTVviEMw2xx466avozdL7nn/WgDYdvrltRkFvavXzJ0lL9vg43+/3xkYhH1cFZ
	1qGkObt/BDl6+mB7r5q9KpWcfHg2fMf2wFNPv5QeV8ylZvgQ7AV5oD+uYuX/AHoN2SJoAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPJsWRmVeSWpSXmKPExsVy+t9jAV03La8Qg46JqhZz1q9hs3j8eh6L
	xYyHv1gsXh7StFi0ewGTxbOmL4wWqzf5WqzsbmazOPXnOpPFzedzWCy2d85gt+h//J3d4vKu
	OWwW99b8Z7VYe+Quu8Xkd88YLRYcb2G1uLb3OLPFt7e32S3+XlnPYtG2ZCOTxfPmVhaLxUdu
	M1vMbuxjtJjSd5fRQdLj8Jv3zB6X+3qZPBZsKvXY9GkSu0fX2ytMHidm/GbxmHcy0OPBoc0s
	Huv+vGLy+Pj0FovH+31X2Tz6tqxi9Diz4Ai7x+bT1R6fN8l5rN+ylSlAMKqB0SYjNTEltUgh
	NS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHGCZKCmWJOaVAoYDE4mIl
	fTtME0JD3HQtYBojdH1DguB6jAzQQMIaxowjDSeZCtbrVWzcu5mxgfGaShcjJ4eEgInE7qWz
	mCBsMYkL99azdTFycQgJLGKUmPD3CiuE85tR4uz3OexdjBwcbALqEscO8ILERQQ+MUvMmjKV
	DaSbWaBEYuGK9SwQDXMZJd6uWsIIkuAU0JK4u/UgM4gtLOAiceLTNrB1LAKqEj/m/wWr4RWw
	lJiwvpsZwhaU+DH5HgvEUHWJSfMWMUPY2hJP3l1ghThVQWLH2ddgvSICThKPJs5lgqgRl5j0
	4CH7BEahWUhGzUIyahaSUbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJEZw4n0nt
	YFzZYHGIUYCDUYmH98YMzxAh1sSy4srcQ4wSHMxKIrwv1bxChHhTEiurUovy44tKc1KLDzGa
	An06kVlKNDkfmNTzSuINjU3MTY1NLU0sTMwslcR5D7RaBwoJpCeWpGanphakFsH0MXFwSjUw
	OvNuUBSuvihZ+FhK8enZtXGKxpc/LqncHtde9znf8bPzGT2BX4tUF/UJbs2/ecFS1XHSrd4J
	1lsE35folV33i1r/c8WlsxkLhG3jbhe8Dcw3iIuOYxE6nl7et1Ax9tOtxpe2lRc+B23dwepq
	emyDzrHJ0u9+ch6JPT21wygiweSKrrzB+s+ZSizFGYmGWsxFxYkAOQu0prIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> From: Michal Nazarewicz <mina86@mina86.com>
> To: Pintu Kumar <pintu.k@samsung.com>; akpm@linux-foundation.org; riel@redhat.com; pintu.k@samsung.com; aquini@redhat.com; paul.gortmaker@windriver.com; jmarchan@redhat.com; lcapitulino@redhat.com; kirill.shutemov@linux.intel.com; m.szyprowski@samsung.com; aneesh.kumar@linux.vnet.ibm.com; iamjoonsoo.kim@lge.com; lauraa@codeaurora.org; gioh.kim@lge.com; mgorman@suse.de; rientjes@google.com; hannes@cmpxchg.org; vbabka@suse.cz; sasha.levin@oracle.com; linux-kernel@vger.kernel.org; linux-mm@kvack.org
> Cc: pintu_agarwal@yahoo.com; cpgs@samsung.com; vishnu.ps@samsung.com; rohit.kr@samsung.com; ed.savinay@samsung.com
> Sent: Thursday, 23 October 2014 10:31 PM
> Subject: Re: [PATCH v2 1/2] mm: cma: split cma-reserved in dmesg log
> 
> On Wed, Oct 22 2014, Pintu Kumar wrote:
>> When the system boots up, in the dmesg logs we can see
>> the memory statistics along with total reserved as below.
>> Memory: 458840k/458840k available, 65448k reserved, 0K highmem
>> 
>> When CMA is enabled, still the total reserved memory remains the same.
>> However, the CMA memory is not considered as reserved.
>> But, when we see /proc/meminfo, the CMA memory is part of free memory.
>> This creates confusion.
>> This patch corrects the problem by properly subtracting the CMA reserved
>> memory from the total reserved memory in dmesg logs.
>> 
>> Below is the dmesg snapshot from an arm based device with 512MB RAM and
>> 12MB single CMA region.
>> 
>> Before this change:
>> Memory: 458840k/458840k available, 65448k reserved, 0K highmem
>> 
>> After this change:
>> Memory: 458840k/458840k available, 53160k reserved, 12288k cma-reserved, 0K 
> highmem
>> 
>> Signed-off-by: Pintu Kumar <pintu.k@samsung.com>
>> Signed-off-by: Vishnu Pratap Singh <vishnu.ps@samsung.com>
> 
> Acked-by: Michal Nazarewicz <mina86@mina86.com>
> 
> 
> I'm not sure how Andrew would think about it, and I don't have strong
> feelings, but I would consider a few changes:
> 
>> ---
>> v2: Moved totalcma_pages extern declaration to linux/cma.h
>>     Removed CONFIG_CMA while show cma-reserved, from page_alloc.c
>>     Moved totalcma_pages declaration to page_alloc.c, so that if will be 
> visible 
>>     in non-CMA cases.
>>   include/linux/cma.h |    1 +
>>   mm/cma.c            |    1 +
>>   mm/page_alloc.c    |    6 ++++--
>>   3 files changed, 6 insertions(+), 2 deletions(-)
>> 
>> diff --git a/include/linux/cma.h b/include/linux/cma.h
>> index 0430ed0..0b75896 100644
>> --- a/include/linux/cma.h
>> +++ b/include/linux/cma.h
>> @@ -15,6 +15,7 @@
>>   
>>   struct cma;
>>   
>> +extern unsigned long totalcma_pages;
> 
> +#ifdef CONFIG_CMA
> +extern unsigned long totalcma_pages;
> +#else
> +#  define totalcma_pages 0UL
> +#endif
> 
>>   extern phys_addr_t cma_get_base(struct cma *cma);
>>   extern unsigned long cma_get_size(struct cma *cma);
>>   
>> diff --git a/mm/cma.c b/mm/cma.c
>> index 963bc4a..8435762 100644
>> --- a/mm/cma.c
>> +++ b/mm/cma.c
>> @@ -288,6 +288,7 @@ int __init cma_declare_contiguous(phys_addr_t base,
>>       if (ret)
>>           goto err;
>>   
>> +    totalcma_pages += (size / PAGE_SIZE);
>>       pr_info("Reserved %ld MiB at %08lx\n", (unsigned 
> long)size / SZ_1M,
>>           (unsigned long)base);
>>       return 0;
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index dd73f9a..ababbd8 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -110,6 +110,7 @@ static DEFINE_SPINLOCK(managed_page_count_lock);
>>   
>>   unsigned long totalram_pages __read_mostly;
>>   unsigned long totalreserve_pages __read_mostly;
>> +unsigned long totalcma_pages __read_mostly;
> 
> Move this to cma.c.
> 

In our earlier patch (first version), we added it in cmc.c itself.
But, Andrew wanted this variable to be visible in non-CMA case as well to avoid build error, when we use 
this variable in mem_init_print_info, without CONFIG_CMA.
So, we moved it to page_alloc.c

>>   /*
>>   * When calculating the number of globally allowed dirty pages, there
>>   * is a certain number of per-zone reserves that should not be
>> @@ -5520,7 +5521,7 @@ void __init mem_init_print_info(const char *str)
>>   
>>       pr_info("Memory: %luK/%luK available "
>>             "(%luK kernel code, %luK rwdata, %luK rodata, "
>> -          "%luK init, %luK bss, %luK reserved"
>> +          "%luK init, %luK bss, %luK reserved, %luK 
> cma-reserved"
>>   #ifdef    CONFIG_HIGHMEM
>>             ", %luK highmem"
>>   #endif
>> @@ -5528,7 +5529,8 @@ void __init mem_init_print_info(const char *str)
>>             nr_free_pages() << (PAGE_SHIFT-10), physpages << 
> (PAGE_SHIFT-10),
>>             codesize >> 10, datasize >> 10, rosize >> 10,
>>             (init_data_size + init_code_size) >> 10, bss_size 
>>> 10,
>> -          (physpages - totalram_pages) << (PAGE_SHIFT-10),
>> +          (physpages - totalram_pages - totalcma_pages) << 
> (PAGE_SHIFT-10),
>> +          totalcma_pages << (PAGE_SHIFT-10),
>>   #ifdef    CONFIG_HIGHMEM
>>             totalhigh_pages << (PAGE_SHIFT-10),
>>   #endif
>> -- 
>> 1.7.9.5
>> 
> 
> -- 
> Best regards,                                        _    _
> .o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
> ..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
> ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> 
> email@kvack.org </a>
>

