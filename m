Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042AbaJFQ0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:26:19 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:18556 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752163AbaJFQ0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:26:17 -0400
X-AuditID: cbfee690-f79ab6d0000046f7-68-5432c2a7829a
Date: Mon, 06 Oct 2014 16:26:15 +0000 (GMT)
From: PINTU KUMAR <pintu.k@samsung.com>
Subject: Re: Re: [PATCH 1/1] [ion]: system-heap use PAGE_ALLOC_COSTLY_ORDER for
 high order
To: Laura Abbott <lauraa@codeaurora.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "rebecca@android.com" <rebecca@android.com>,
        "ccross@android.com" <ccross@android.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: IQBAL SHAREEF <iqbal.ams@samsung.com>,
        "pintu_agarwal@yahoo.com" <pintu_agarwal@yahoo.com>,
        Vishnu Pratap Singh <vishnu.ps@samsung.com>,
        "cpgs@samsung.com" <cpgs@samsung.com>
Reply-to: pintu.k@samsung.com
MIME-version: 1.0
X-MTR: 20141006153958031@pintu.k
Msgkey: 20141006153958031@pintu.k
X-EPLocale: en_US.windows-1252
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-MLAttribute: 
X-RootMTR: 20141006153958031@pintu.k
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: Y
X-ConfirmMail: N,general
Content-type: text/plain; charset=windows-1252
MIME-version: 1.0
Message-id: <1689163249.303621412612771982.JavaMail.weblogic@epmlwas07b>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsWyRsSkSnf5IaMQg5mfDC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGzo0nGAt+yVWsO72KvYFxglwXIweHkICSxOtFtl2MnBwSAiYS
	W86sZ4awxSQu3FvPBmILCSxllDj5UQ2m5vXL70xdjFxA8TmMEsdubwJrYBFQkVi8cj8LiM0m
	oCGx8skFsLiwQJTEh93/2UAaRATuMEs8+HYKzGEW2MMo8aP7DRvEFbISlzu5QBp4BQQlTs58
	wgISlhBQkPiyzxEirCix+Pc3dogj5CSWTL3MBGHzSsxof8oCE5/2dQ3UA9IS52dtYIR5ZvH3
	x1BxfqCbd0D1CkhMPXMQqkZVYk3Xaag5fBJrFr5lganfdWo5M8yuho2/oW6QkNja8oQVxGYG
	um1K90N2CNtA4siiOazoXuEV8JD4v1MC5HMJgYkcEgdf3GGcwKg0C0nZLCSjZiEZhaxmASPL
	KkbR1ILkguKk9CITveLE3OLSvHS95PzcTYzAtHD637MJOxjvHbA+xCjAwajEwxu5wzBEiDWx
	rLgy9xCjKTCaJjJLiSbnA5NPXkm8obGZkYWpiamxkbmlmZI472upn8FCAumJJanZqakFqUXx
	RaU5qcWHGJk4OKUaGN1X20SxaiqWW+5W0/9l4n747pk7XJoSmg91+Y9ek5phmyJp4bx0Q+ST
	qHt9y86qz5y/aWbR00p/Vj3rrBVHvj87NHeSq5R7w2aLkopLHotPX3fMX/05fqHTlqRbphZa
	XaFv+pqXh8ncDND6x3r40ylte30F4aqbCrobP+lXr1/j9rtu3mT7iUosxRmJhlrMRcWJAAvx
	JpQGAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKKsWRmVeSWpSXmKPExsVy+t/tXt3lh4xCDL4e17S4vGsOmwOjx+dN
	cgGMUWk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StGG5kZ6RgZ6pkZ6hqaxVoYGBkamQDUJaRk7
	N55gLPglV7Hu9Cr2BsYJcl2MHBxCAkoSrxfZdjFyckgImEi8fvmdCcIWk7hwbz1bFyMXUMkc
	RoljtzcxgyRYBFQkFq/czwJiswloSKx8cgEsLiwQJfFh93+wBhGBO8wSD76dAnOYBfYwSvzo
	fsMGsU1W4nInF0gDr4CgxMmZT1hAwhICChJf9jlChBUlFv/+xg5xhJzEkqmXoQ7ilZjR/pQF
	Jj7t6xpmCFta4vysDYwwRy/+/hgqzg908w6oXgGJqWcOQtWoSqzpOg01h09izcK3LDD1u04t
	Z4bZ1bDxN9QNEhJbW56wgtjMQLdN6X7IDmEbSBxZNIcV3Su8Ah4S/3dKTGCUnYUkMwtJ9ywk
	3chqFjCyrGIUTS1ILihOSq8w1CtOzC0uzUvXS87P3cQITkLPFu5g/HLe+hCjAAejEg9vxA7D
	ECHWxLLiytxDjBIczEoivObzjEKEeFMSK6tSi/Lji0pzUosPMZoCI20is5Rocj4wQeaVxBsa
	m5ibGptaGBiam5spifPevZkUJCSQnliSmp2aWpBaBNPHxMEp1cAoortA3kl5w2+zc6lS5/q6
	bsspbGWU27BK57RZh1co6w2zjtp/5/wfJappBz3veMkhkHpMaKo03wwBQZkrpsv+qa1b0D7T
	arlZnlKa1YPt4T0fNgQeuvdmT+Wz0D2rRaXsq+8+dvuh9JuhPGQ9s/Jtz9Y/AtMOfe2csv3A
	m70qO6t+7v4xm0dUiaU4I9FQi7moOBEAMbQNvFgDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s96GQObZ007703

Hi,
>________________________________
> From: Laura Abbott <lauraa@codeaurora.org>
>To: Heesub Shin <heesub.shin@samsung.com>; Pintu Kumar <pintu.k@samsung.com>; akpm@linux-foundation.org; gregkh@linuxfoundation.org; john.stultz@linaro.org; rebecca@android.com; ccross@android.com; devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org 
>Cc: iqbal.ams@samsung.com; pintu_agarwal@yahoo.com; vishnu.ps@samsung.com 
>Sent: Monday, 6 October 2014 7:37 PM
>Subject: Re: [PATCH 1/1] [ion]: system-heap use PAGE_ALLOC_COSTLY_ORDER for high order
> 
>
>On 10/6/2014 3:27 AM, Heesub Shin wrote:
>
>
>
>
>> Hello Kumar,
>>
>> On 10/06/2014 05:31 PM, Pintu Kumar wrote:
>>> The Android ion_system_heap uses allocation fallback mechanism
>>> based on 8,4,0 order pages available in the system.
>>> It changes gfp flags based on higher order allocation request.
>>> This higher order value is hard-coded as 4, instead of using
>>> the system defined higher order value.
>>> Thus replacing this hard-coded value with PAGE_ALLOC_COSTLY_ORDER
>>> which is defined as 3.
>>> This will help mapping the higher order request in system heap with
>>> the actual allocation request.
>>
>> Quite reasonable.
>>
>> Reviewed-by: Heesub Shin <heesub.shin@samsung.com>
>>
>> BTW, Anyone knows how the allocation order (8,4 and 0) was decided? I
>> think only Google guys might know the answer.
>>
>> regards,
>> heesub
>>
>
>My understanding was this was completely unrelated to the costly order
>and was related to the page sizes corresponding to IOMMU page sizes
>(1MB, 64K, 4K). This won't make a difference for the uncached page
>pool case but for the not page pool case, I'm not sure if there would
>be a benefit for trying to get 32K pages with some effort vs. just
>going back to 4K pages.

No, it is not just related to IOMMU case. It comes into picture also for 
normal system-heap allocation (without iommu cases).
Also, it is applicable for both uncached and page_pool cases.
Please also check the changes under ion_system_heap_create.
Here the gfp_flags are set under the pool structure.
This value is used in ion_page_pool_alloc_pages.
In both the cases, it internally calls alloc_pages, with this gfp_flags.
Now, during memory pressure scenario, when alloc_pages moves to slowpath 
this gfp_flags will be used to decide allocation retry.
In the current code, the higher-order flag is set only when order is greater than 4.
But, in MM, the order 4 is also considered as higher-order request. 
This higher-order is decided based on PAGE_ALLOC_COSTLY_ORDER (3) value.
Hence, I think this value should be in sync with the MM code.

>
>Do you have any data/metrics that show a benefit from this patch?
I think it is not related to any data or metrics.
It is about replacing the hard-coded higher-order check to be in sync with 
the MM code.

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
