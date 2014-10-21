Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932761AbaJUNWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:22:37 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:58530 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500AbaJUNWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:22:34 -0400
X-AuditID: cbfee68e-f79b46d000002b74-b3-54465e18adce
From: PINTU KUMAR <pintu.k@samsung.com>
To: "'Gioh Kim'" <gioh.kim@lge.com>, akpm@linux-foundation.org,
        hannes@cmpxchg.org, riel@redhat.com, mgorman@suse.de,
        vdavydov@parallels.com, nasa4836@gmail.com, ddstreet@ieee.org,
        m.szyprowski@samsung.com, mina86@mina86.com, iamjoonsoo.kim@lge.com,
        aneesh.kumar@linux.vnet.ibm.com, lauraa@codeaurora.org,
        rientjes@google.com, vbabka@suse.cz, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, pintu.k@samsung.com
Cc: cpgs@samsung.com, pintu_agarwal@yahoo.com, vishnu.ps@samsung.com,
        rohit.kr@samsung.com, ed.savinay@samsung.com,
        =?ks_c_5601-1987?B?J8DMsMfIoyc=?= <gunho.lee@lge.com>
References: <1413790391-31686-1-git-send-email-pintu.k@samsung.com>
 <5445AD12.9080502@lge.com>
In-reply-to: <5445AD12.9080502@lge.com>
Subject: RE: [PATCH] mm: cma: split cma-reserved in dmesg log
Date: Tue, 21 Oct 2014 18:51:30 +0530
Message-id: <00cd01cfed32$1ebfd5b0$5c3f8110$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIYigTjXepmiJMFsP3pxyBCbUOBxwGJA7Y2m5z6irA=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUhTURjHO7t3905pcVtax4WUgkSOzHzraC8UpJ0PBZV+iIp02s1pOsc2
	I3sBzZRUHOrKdIpMU6q5Gs5CUyydlqlZhhrlmEyriflWFpZY2qYL/Pb7n+c5z///wMMjBO+5
	Ql6CVMnKpeIkb8qV1LsFXdsBz0ZE+d+sEKFyg55CnyYqSDRu2o76sptJVNWs5SDb9Z8A9RVX
	EqjWeBQ9yMukUENOCY36m8opNKxf4qKHHRYaqadtAGk7b3BR9tsCCql+tdNobspMo78DBhJl
	V9dx0FhmFonudpgJVJahAqj/SSmBbqks4IAHbp+cIXC/Kp+Dn2osNNYaU/GXgjYONs4W0Th3
	aoCDX5UskNhqqifxoz9fOfj7lyESd1XMU3jm2SCFVY91AL/WdtC4vufKMcEp173n2KSEi6x8
	5/4YV8mbsV5athR0yZhBpQO1by5w4UEmCOY9z+Ou8EbYN2ygcoErT8DUAJjenE/+b9KNFzoL
	VQCaX/wAK2IBwNGsLrvg8ShmG3zZyne8uzHPCFibW0w7BME8BNCotnIcowRMDGxvaKAc7GL/
	kFlaBhy8gdkHtS0GwsEk4wPfmS20g/lMKBxdtDp5PfytHl6ORDD+cEaj4q6wCH6e7nPusBU2
	9k4sz3RjwuCgwers2QSLrCPLgSBT7wLrxrqdZgycU5tIxwaQ8YTGVmJljgdsu/+BLABQs8pa
	s8pas8pas8pCC0gdcGdlcTJFbLw8wE8hTlakSuP94lKSjcB+bj2LNlUj+Ni6xwQYHvBeyz9Z
	HR4l4IovKtKSTSDYnqiQELrHpdgvVKqM3hUYEoCCg4IDA3aHhnhv4scI5yMFTLxYyV5gWRkr
	j5anJrEKE+DwXITpgNRM5zTh1se9lyMlSu7BuYiaanUhd+HOIH5eLkksKpNZTnw0b1mz1Nmx
	TuSfHihKe+CVOaR7GyycPFrrU1kfFRGXcei2IKm/5bQt1jaFQGyKPqzr6uiR7nsNFZ6JVwdC
	UhY3CyJHzh7/Vu33bf7lGelhvkbSHf5hyWvWa+I86vQmFRLxLl9CrhD/A4kZrotpAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA2WSe0hTURzHO7t3917F0XVanQxKLoRkrTabdVYZQTVuZWA1YT3tphe13Ga7
	ai+ilSm0atkssfVa5j9NbbQMe5DotIf0WmlRrclKU6zUXvRO27RC6vz1+f043w+/c/hRmNRO
	RFGZ+hzeqOeyGCIUv9XXRsvgGrVG/qp+LDrmrCRQ2+sTOOpyT0Cewis4KrtiF6GOXR8B8pSc
	wlCFazE6szefQDV7SknUfPkYgVor+8WoqtFHouKeDoDsN3aLUeG9IgJZPjeQ6FO3l0Q/W5w4
	Kiw/J0Kd+QU4Ot3oxdDRnRaAmi8cwdAhiw/MGc02vOnF2GbLfhF7yeYjWbsrl31ZVC9iXe+t
	JGvubhGxN0u/46zffR5nz/54JWLfvXyKs00nvhJsb+1DgrVUOwB7295IsudvbUuSrjCBWRk8
	l8Ybo3l9qiEtU5+ewCxaljI3JX6aXCFTqNB0JlrP6fgEZl5ikkydmRX4FSY6j8vKDbSSOEFg
	psz+35CsUcvQn6BWtliz9G8mTv7PWVsJMu523iGz+5WbXTsJEyiONYMQCtJK6Og6SAzySOhp
	dQY4lJLSZQB6r30Ag8V3AF8UNAUKiiLoGHi9ThLsR9K1GKwwl5DBAqOrAHQV+0VBlZReCxtq
	aga0IYFA/pGjIMgRdAK0X3ViQcbp8fC+10cGWUKr4Is+/28Oh1+KW/EgY7Qc9tos4kGeCNt7
	POLBUaPhxTuvB5yR9Az40On/fWcUtPqfk0VAahuisg1R2YaobEMidoA7wAg+OzVbWJeui5ss
	cDohV58+OdWgc4GB7ewYcxE4TMgNaAowYRJt+XyNVMzlCVt0bgApjImU6CLUGqkkjduylTca
	Uoy5WbzgBvGBlx7EokakGgK7rs9JUUxVTo+fGq9SIuU0FTNKUl8wc4mUTudy+A08n80b/+RE
	VEiUCZQahuu7sYh9C8qqJE2q8GUbVe3n4np29Lejs09/CtUx6rAnFavWP0qc5K7Oa1HUPbNo
	86wPNtV19RjHnPSNC19+3NwVJv+sXWg2PdYq8cOh8w6s+mpUNm/fWtLZNHH8bkdbQQhIrF1k
	/cavfutKfnPTWz5l2EraGrNRLvbYvco+BhcyOEUsZhS4X5phVnizAwAA
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
hannes@cmpxchg.org; riel@redhat.com; mgorman@suse.de;
vdavydov@parallels.com; nasa4836@gmail.com; ddstreet@ieee.org;
m.szyprowski@samsung.com; mina86@mina86.com; iamjoonsoo.kim@lge.com; aneesh.
kumar@linux.vnet.ibm.com; lauraa@codeaurora.org; rientjes@google.com;
vbabka@suse.cz; sasha.levin@oracle.com; linux-kernel@vger.kernel.org; linux-
mm@kvack.org
> Cc: cpgs@samsung.com; pintu_agarwal@yahoo.com; vishnu.ps@samsung.com;
rohit.kr@samsung.com; ed.savinay@samsung.com; 이건호 <gunho.lee@lge.com>
> Sent: Tuesday, 21 October 2014 6:17 AM
> Subject: Re: [PATCH] mm: cma: split cma-reserved in dmesg log
> 
> 
> 
> 2014-10-20 오후 4:33, Pintu Kumar 쓴 글:
>> When the system boots up, in the dmesg logs we can see
>> the memory statistics along with total reserved as below.
>> Memory: 458840k/458840k available, 65448k reserved, 0K highmem
>> 
>> When CMA is enabled, still the total reserved memory remains the same.
>> However, the CMA memory is not considered as reserved.
>> But, when we see /proc/meminfo, the CMA memory is part of free memory.
>> This creates confusion.
>> This patch corrects the problem by properly substracting the CMA reserved
>> memory from the total reserved memory in dmesg logs.
>> 
>> Below is the dmesg snaphot from an arm based device with 512MB RAM and
>> 12MB single CMA region.
>> 
>> Before this change:
>> Memory: 458840k/458840k available, 65448k reserved, 0K highmem
>> 
>> After this change:
>> Memory: 458840k/458840k available, 53160k reserved, 12288k cma-reserved,
0K 
> highmem
>> 
>> Signed-off-by: Pintu Kumar <pintu.k@samsung.com>
>> Signed-off-by: Vishnu Pratap Singh <vishnu.ps@samsung.com>
>> ---
>>   include/linux/swap.h | 3 +++
>>   mm/cma.c            | 2 ++
>>   mm/page_alloc.c      | 8 ++++++++
>>   3 files changed, 13 insertions(+)
>> 
>> diff --git a/include/linux/swap.h b/include/linux/swap.h
>> index 37a585b..beb84be 100644
>> --- a/include/linux/swap.h
>> +++ b/include/linux/swap.h
>> @@ -295,6 +295,9 @@ static inline void
workingset_node_shadows_dec(struct 
> radix_tree_node *node)
>>   /* linux/mm/page_alloc.c */
>>   extern unsigned long totalram_pages;
>>   extern unsigned long totalreserve_pages;
>> +#ifdef CONFIG_CMA
>> +extern unsigned long totalcma_pages;
>> +#endif

Ok, as per Andrew Morton comment, will remove CONFIG_CMA, 
But then I need to put it under: include/linux/mm.h
In that case, it will solve the problem for CMA and non-CMA case.
Because, mm.h is already included in cma.c

>>   extern unsigned long dirty_balance_reserve;
>>   extern unsigned long nr_free_buffer_pages(void);
>>   extern unsigned long nr_free_pagecache_pages(void);
>> diff --git a/mm/cma.c b/mm/cma.c
>> index 963bc4a..73fe7be 100644
>> --- a/mm/cma.c
>> +++ b/mm/cma.c
>> @@ -45,6 +45,7 @@ struct cma {
>>   static struct cma cma_areas[MAX_CMA_AREAS];
>>   static unsigned cma_area_count;
>>   static DEFINE_MUTEX(cma_mutex);
>> +unsigned long totalcma_pages __read_mostly;
> 
> I think __read_mostly is not good here.
> Cma areas often are rare
> but we cannot expect how many cma areas exists.
> 

Firstly, I want to move this to mm/page_alloc.c, so that it can be visible
for non-CMA cases.
Next, the purpose this variable is not only during init time.
Just like totalram_pages, I wanted to retain this variable to use it to
populate the CMA info, during /proc/meminfo.
Like:
CMATotal: (using totalcma_pages)
CMAFree:  (using NR_FREE_CMA_PAGES)
I will post these changes in the next patch series.
Please let me know your comments.

>>   
>>   phys_addr_t cma_get_base(struct cma *cma)
>>   {
>> @@ -288,6 +289,7 @@ int __init cma_declare_contiguous(phys_addr_t base,
>>       if (ret)
>>           goto err;
>>   
>> +    totalcma_pages += (size / PAGE_SIZE);
>>       pr_info("Reserved %ld MiB at %08lx\n", (unsigned 
> long)size / SZ_1M,
>>           (unsigned long)base);
>>       return 0;
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index dd73f9a..c6165ac 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -5521,6 +5521,9 @@ void __init mem_init_print_info(const char *str)
>>       pr_info("Memory: %luK/%luK available "
>>             "(%luK kernel code, %luK rwdata, %luK rodata, "
>>             "%luK init, %luK bss, %luK reserved"
>> +#ifdef CONFIG_CMA
>> +        ", %luK cma-reserved"
>> +#endif
>>   #ifdef    CONFIG_HIGHMEM
>>             ", %luK highmem"
>>   #endif
>> @@ -5528,7 +5531,12 @@ void __init mem_init_print_info(const char *str)
>>             nr_free_pages() << (PAGE_SHIFT-10), physpages << 
> (PAGE_SHIFT-10),
>>             codesize >> 10, datasize >> 10, rosize >> 
> 10,
>>             (init_data_size + init_code_size) >> 10, bss_size 
>>> 10,
>> +#ifdef CONFIG_CMA
>> +          (physpages - totalram_pages - totalcma_pages) << 
> (PAGE_SHIFT-10),
>> +          totalcma_pages << (PAGE_SHIFT-10),
>> +#else
>>             (physpages - totalram_pages) << (PAGE_SHIFT-10),
>> +#endif
>>   #ifdef    CONFIG_HIGHMEM
>>             totalhigh_pages << (PAGE_SHIFT-10),
>>   #endif
>> 
> 
> I basically agree with your point.
> But CMA feature is not popular yet, so memory develoers probably doesn't 
> like this.
> 

Ok agree. If we move totalcma_pages declaration to page_alloc.c and mm.h,
then we can get rid of CONFIG_CMA, to make it neat.


> I'm not sure but I think there is a debugfs file for cma.
> Can you use it?
> 

As of now, I think there is no debugfs for cma.
However, we can make one if required.

> Or what do you think about making another proc file to show cma area size
and 
> address?
> For instance,
> 
> # cat /proc/cmainfo
> CMATotal:    400kB
> 0x10000000  300kB
> 0x20000000  100kB
> 

I think this is not required.
For multiple CMA regions, this can be found under:
/sys/kernel/debug/memblock/reserved
However, as I said, we can populate this information under: /proc/meminfo
I think capturing it at one place will be better. For non-CMA cases, it
will be hidden.
Thus summary of CMA info can be seen in meminfo, and detailed information
can be seen in memblock/reserved.
Do, let me know if you have any other idea?

> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> 
> email@kvack.org </a>
>

