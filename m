Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbaJGQHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:07:51 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36852 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbaJGQHr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:07:47 -0400
X-AuditID: cbfee68d-f79296d000004278-49-54340fd043e5
From: PINTU KUMAR <pintu.k@samsung.com>
To: "'Colin Cross'" <ccross@android.com>
Cc: "'Laura Abbott'" <lauraa@codeaurora.org>,
        "'Heesub Shin'" <heesub.shin@samsung.com>, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, john.stultz@linaro.org,
        rebecca@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "'IQBAL SHAREEF'" <iqbal.ams@samsung.com>, pintu_agarwal@yahoo.com,
        "'Vishnu Pratap Singh'" <vishnu.ps@samsung.com>, cpgs@samsung.com
References: <1689163249.303621412612771982.JavaMail.weblogic@epmlwas07b>
 <CAMbhsRSiA=yo21EHBZX96sq+EPKkjSHrnMqN-02kzWe8pHjkqA@mail.gmail.com>
In-reply-to: <CAMbhsRSiA=yo21EHBZX96sq+EPKkjSHrnMqN-02kzWe8pHjkqA@mail.gmail.com>
Subject: RE: Re: [PATCH 1/1] [ion]: system-heap use PAGE_ALLOC_COSTLY_ORDER for
 high order
Date: Tue, 07 Oct 2014 21:37:38 +0530
Message-id: <02b901cfe248$da28bfa0$8e7a3ee0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJ0aFKfqgr2C61R6MVlRKHG3mr2GgJCNRs1msmnKfA=
Content-language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsWyRsSkRvciv0mIwZN3bBZz1q9hs9i+8Rur
	xctDmhZ7zvxit2hevJ7N4uDsJUwWs39NYrI481vXYnvnDHaLy7vmsFl8e3ub3eLG5EKLKX13
	GR14Pbbt3sbqcbmvl8nj3r7DLB53ru1h8zgx4zeLx/65a9g9+rasYvT4vEnOY9asw0wBnFFc
	NimpOZllqUX6dglcGZ2T9rIWLNGq6Hp5hL2B8YFSFyMnh4SAiUTLpZ3MELaYxIV769m6GLk4
	hASWMkp0rrnNDle0bhpUYjqjROvpJSwgCSGB34wST3oluhg5ONgE1CWOHeAFCYsIqEnc/HSA
	BaSeWeAfk8Tzfc1Q9f2MEme/5IHYnALBEg9mzAdbICwQI3Hv6VxWkDksAqoSE5+Ig4R5BSwl
	fn9tYYGwBSV+TL7HAlLCDLRqypRckDCzgLbEk3cXWCHOVJDYcfY1I8QJVhJvp+9lgqgRl5j0
	4CHUK2s5JCafZwOxWQQEJL5NPgQ2UkJAVmLTAWgwSEocXHGDZQKjxCwki2chLJ6FZPEsJAsW
	MLKsYhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAhMCqf/PevdwXj7gPUhRgEORiUe3hVaxiFC
	rIllxZW5hxhNgQ6ayCwlmpwPTD15JfGGxmZGFqYmpsZG5pZmSuK8ilI/g4UE0hNLUrNTUwtS
	i+KLSnNSiw8xMnFwSjUwLnFmWa18qipS7LV5ypQdq9fpvLrnkaURUmKveqxgm8UFNc4bDL99
	NWUn1/C+69s5lf1ge71xpwav3tfsTz//BtySTXfVZPnQfVbgVkJbx5vikJlHTxnfExNUKiiq
	eDL1+rErdwU+s8WdFqlyVK6fZNS+/+gqxr15kRWLHuvxds75/9VZxCtRiaU4I9FQi7moOBEA
	tkYvCAUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsVy+t9jQd0L/CYhBl2nLC3mrF/DZrF94zdW
	i5eHNC32nPnFbtG8eD2bxcHZS5gsZv+axGRx5reuxfbOGewWl3fNYbP49vY2u8WNyYUWU/ru
	MjrwemzbvY3V43JfL5PHvX2HWTzuXNvD5nFixm8Wj/1z17B79G1ZxejxeZOcx6xZh5kCOKMa
	GG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgM5WUihL
	zCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGZ0TtrLWrBEq6Lr5RH2BsYHSl2M
	nBwSAiYSLeumsUHYYhIX7q0Hsrk4hASmM0q0nl7CApIQEvjNKPGkV6KLkYODTUBd4tgBXpCw
	iICaxM1PB1hA6pkF/jFJPN/XDFXfzyhx9kseiM0pECzxYMZ8dhBbWCBG4t7Tuawgc1gEVCUm
	PhEHCfMKWEr8/trCAmELSvyYfI8FpIQZaNWUKbkgYWYBbYkn7y6wQpypILHj7GtGiBOsJN5O
	38sEUSMuMenBQ/YJjEKzkEyahTBpFpJJs5B0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yf
	u4kRnHSeSe9gXNVgcYhRgINRiYd3hZZxiBBrYllxZe4hRgkOZiUR3qmcJiFCvCmJlVWpRfnx
	RaU5qcWHGE2B3pzILCWanA9MiHkl8YbGJuamxqaWJhYmZpZK4rwHW60DhQTSE0tSs1NTC1KL
	YPqYODilGhgVA5YxujAl9RXELXmSmyjhtqAy4Uyuzn/DHW7Fd21vuGTtj0800miVF57MEWG1
	Qu6xMssCNqaes+d5ugWq7PZdtRFLPOFp6q+imGiaYih6ddLR+FrPzT8f5dyRqW9i3zizz4Mh
	voz3Qqnnu28TVv6y95/JMN9UJc6F5925+L86DW93aOUaK7EUZyQaajEXFScCAHHMDClQAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> From: Colin Cross <ccross@android.com>
> To: pintu.k@samsung.com
> Cc: Laura Abbott <lauraa@codeaurora.org>; Heesub Shin <heesub.shin@samsung.com>; "akpm@linux-foundation.org" <akpm@linux-foundation.org>; "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>; "john.stultz@linaro.org" <john.stultz@linaro.org>; "rebecca@android.com" <rebecca@android.com>; "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>; "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; IQBAL SHAREEF <iqbal.ams@samsung.com>; "pintu_agarwal@yahoo.com" <pintu_agarwal@yahoo.com>; Vishnu Pratap Singh <vishnu.ps@samsung.com>; "cpgs@samsung.com" <cpgs@samsung.com>
> Sent: Monday, 6 October 2014 11:01 PM
> Subject: Re: Re: [PATCH 1/1] [ion]: system-heap use PAGE_ALLOC_COSTLY_ORDER for high order
> 
> On Mon, Oct 6, 2014 at 9:26 AM, PINTU KUMAR <pintu.k@samsung.com> wrote:
> 
>> 
>> Hi,
>> >________________________________
>> > From: Laura Abbott <lauraa@codeaurora.org>
>> >To: Heesub Shin <heesub.shin@samsung.com>; Pintu Kumar 
> <pintu.k@samsung.com>; akpm@linux-foundation.org; 
> gregkh@linuxfoundation.org; john.stultz@linaro.org; rebecca@android.com; 
> ccross@android.com; devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org
>> >Cc: iqbal.ams@samsung.com; pintu_agarwal@yahoo.com; 
> vishnu.ps@samsung.com
>> >Sent: Monday, 6 October 2014 7:37 PM
>> >Subject: Re: [PATCH 1/1] [ion]: system-heap use PAGE_ALLOC_COSTLY_ORDER 
> for high order
>> >
>> >
>> >On 10/6/2014 3:27 AM, Heesub Shin wrote:
>> >
>> >
>> >
>> >
>> >> Hello Kumar,
>> >>
>> >> On 10/06/2014 05:31 PM, Pintu Kumar wrote:
>> >>> The Android ion_system_heap uses allocation fallback mechanism
>> >>> based on 8,4,0 order pages available in the system.
>> >>> It changes gfp flags based on higher order allocation request.
>> >>> This higher order value is hard-coded as 4, instead of using
>> >>> the system defined higher order value.
>> >>> Thus replacing this hard-coded value with 
> PAGE_ALLOC_COSTLY_ORDER
>> >>> which is defined as 3.
>> >>> This will help mapping the higher order request in system heap 
> with
>> >>> the actual allocation request.
>> >>
>> >> Quite reasonable.
>> >>
>> >> Reviewed-by: Heesub Shin <heesub.shin@samsung.com>
>> >>
>> >> BTW, Anyone knows how the allocation order (8,4 and 0) was 
> decided? I
>> >> think only Google guys might know the answer.
>> >>
>> >> regards,
>> >> heesub
>> >>
>> >
>> >My understanding was this was completely unrelated to the costly order
>> >and was related to the page sizes corresponding to IOMMU page sizes
>> >(1MB, 64K, 4K). This won't make a difference for the uncached page
>> >pool case but for the not page pool case, I'm not sure if there 
> would
>> >be a benefit for trying to get 32K pages with some effort vs. just
>> >going back to 4K pages.
>> 
>> No, it is not just related to IOMMU case. It comes into picture also for
>> normal system-heap allocation (without iommu cases).
>> Also, it is applicable for both uncached and page_pool cases.
>> Please also check the changes under ion_system_heap_create.
>> Here the gfp_flags are set under the pool structure.
>> This value is used in ion_page_pool_alloc_pages.
>> In both the cases, it internally calls alloc_pages, with this gfp_flags.
>> Now, during memory pressure scenario, when alloc_pages moves to slowpath
>> this gfp_flags will be used to decide allocation retry.
>> In the current code, the higher-order flag is set only when order is 
> greater than 4.
>> But, in MM, the order 4 is also considered as higher-order request.
>> This higher-order is decided based on PAGE_ALLOC_COSTLY_ORDER (3) value.
>> Hence, I think this value should be in sync with the MM code.
>> >
>> >Do you have any data/metrics that show a benefit from this patch?
>> I think it is not related to any data or metrics.
>> It is about replacing the hard-coded higher-order check to be in sync with
>> the MM code.
>> 
> 
> The selection of the orders used for allocation (8, then 4, then 0) is
> designed to match with the sizes often found in IOMMUs, but this isn't
> changing the order of the allocation, it is changing the GFP flags
> used for the order 4 allocation.  Right now we are using the
> low_order_gfp_flags for order 4, this patch would change it to use
> high_order_gfp_flags.  We originally used low_order_gfp_flags here
> because the MM subsystem can usually satisfy these allocations, and
> the additional load placed on the MM subsystem to kick off kswapd to
> free up more order 4 chunks is generally worth it.  Using order 4
> pages instead of order 0 pages can significantly improve the
> performance of many IOMMUs by reducing TLB pressure and time spent
> updating page tables.  Unless you have data showing that this improves
> something, and doesn't just cause all allocations to be order 0 when
> under memory pressure, I don't suggest merging this.
>

Ok agree. It is worth retrying the allocation with order-4 pages.
But, since 4 is considered higher order for MM and is greater than PAGE_ALLOC_COSTLY_ORDER.
I guess the retrying will not happen, because of the following check in page_alloc:
if (order > PAGE_ALLOC_COSTLY_ORDER)
	goto nopage;



