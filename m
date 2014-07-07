Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbaGGKgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 06:36:44 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:64170 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaGGKgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 06:36:41 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-e9-53ba7835fae8
Message-id: <53BA7838.7000706@samsung.com>
Date: Mon, 07 Jul 2014 12:36:40 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org
Cc: "'Benjamin Herrenschmidt'" <benh@kernel.crashing.org>,
        "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Grant Likely'" <grant.likely@linaro.org>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Sascha Hauer'" <s.hauer@pengutronix.de>,
        "'Laura Abbott'" <lauraa@codeaurora.org>,
        "'Rob Herring'" <robh+dt@kernel.org>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Pawel Moll'" <pawel.moll@arm.com>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Stephen Warren'" <swarren@wwwdotorg.org>,
        "'Ian Campbell'" <ian.campbell@citrix.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Nishanth Peethambaran'" <nishanth.p@gmail.com>,
        "'Marc'" <marc.ceeeee@gmail.com>,
        "'Josh Cartwright'" <joshc@codeaurora.org>,
        "'Catalin Marinas'" <catalin.marinas@arm.com>,
        "'Will Deacon'" <will.deacon@arm.com>,
        "'Paul Mackerras'" <paulus@samba.org>,
        "'Jon Medhurst'" <tixy@linaro.org>,
        "'Aneesh Kumar K.V.'" <aneesh.kumar@linux.vnet.ibm.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] drivers: dma-contiguous: add initialization from
 device tree
References: <1404298132-6050-1-git-send-email-m.szyprowski@samsung.com>
 <1404298132-6050-5-git-send-email-m.szyprowski@samsung.com>
 <00b501cf974c$2db1a800$8914f800$@lge.com>
In-reply-to: <00b501cf974c$2db1a800$8914f800$@lge.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA03SW0jTURzAcc7+t21o/JsaJxGTYS9G5qDLKTSkEP5PZUiGEdrU5YVNbUvz
	QqSmptu8pIg2ZWpeqLFLOvAyDHUMFRVJXAo1b0mYTueViJyS2158+/wO33POy4+N8X7j/uy0
	jBciaYZQzCe5+OTx2Ozla7mmmLB6xyXUbNCSaNWuxtFR7SiFdopLMbTdpQSoxTJNoOrNNgIN
	O/sB+qR4Q6LNynIcDegdAPVVNFLowLrCQj2rcwRqK+vA0aypmUSf10dYqHN+hoVax0oI5GwI
	RBPz+yTSWtopVNOgw1HpFwuFjvp6cLQxUoYjQ6MdR20tSxTSmJwAre+O45GBjFatBczhv1rA
	2OtqADNbVcliBlQLFKPcLCGYHk0Fyci3rCzGNjdIMuONhzizbDbijLHjNfPjeBVjrOPFBKN3
	brCY6qOwaN/H3PBkkTgtRyS9cvspN3X6Ww2VpaNzdctdZCHY85IDDhvSV+G6cZj0+Bz8umg4
	MZfNozsBtH1XU55hD8Ah9S935U2HQIW+ym2cvgh7m9Ywl0laAOVbcve5H/0ETlXuY57+LPxb
	t4i7HvKlxwBcLKx2Dxi9QcFDu4blqnzoR/DPQqX7No/uBnDE5jaHvg4N9mXCZezEP0v0mMcX
	oFG7hdUAWnXqE9WpTHUqawWYBviJspOyZIkpEkGoTCiRZWekhCZlSnqAZzsO+kH76C0zoNmA
	7+W9Yx2I4RHCHFmexAwgG+P7ejckmGJ43snCvHyRNDNBmi0WycyAxeb4F4JXEe/9PnQ7Ji0P
	03vzg0wTLwXB97nCgL4mNYdbvbLYKfGP9tHcqNgdFD+bV8XbOmOLUnS8qP0ZMha3RN4dSo96
	d6a2QDkVqJTTyS1xvgqfgXKHJABK93biih4kxtev3VFE5K0QQTrldn/wvefhtsTij+dzFTep
	JetbsF/A5+OyVKEgBJPKhP8Bp/34rfsCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-07-04 07:52, Joonsoo Kim wrote:
>> -----Original Message-----
>> From: Marek Szyprowski [mailto:m.szyprowski@samsung.com]
>> Sent: Wednesday, July 02, 2014 7:49 PM
>>
>> Subject: [PATCH 4/4] drivers: dma-contiguous: add initialization from
>> device tree
>>
>> Add a code to create CMA region from reserved memory and add support for
>> handling 'shared-dma-pool' reserved-memory device tree nodes.
>>
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> ---
>>   drivers/base/dma-contiguous.c | 67
>> +++++++++++++++++++++++++++++++++++++++++
>>   include/linux/cma.h           |  3 ++
>>   mm/cma.c                      | 69
> ++++++++++++++++++++++++++++++++-----------
>>   3 files changed, 122 insertions(+), 17 deletions(-)
>>

...

>> +/**
>>    * cma_declare_contiguous() - reserve custom contiguous area
>>    * @base: Base address of the reserved area optional, use 0 for any
>>    * @size: Size of the reserved area (in bytes),
>> @@ -162,18 +210,12 @@ int __init cma_declare_contiguous(phys_addr_t base,
>>   			phys_addr_t alignment, unsigned int order_per_bit,
>>   			bool fixed, struct cma **res_cma)
>>   {
>> -	struct cma *cma;
>> -	int ret = 0;
>> +	int ret;
>>
>>   	pr_debug("%s(size %lx, base %08lx, limit %08lx alignment %08lx)\n",
>>   		__func__, (unsigned long)size, (unsigned long)base,
>>   		(unsigned long)limit, (unsigned long)alignment);
>>
>> -	if (cma_area_count == ARRAY_SIZE(cma_areas)) {
>> -		pr_err("Not enough slots for CMA reserved regions!\n");
>> -		return -ENOSPC;
>> -	}
>> -
> Hello, Marek.
>
> After this change, if we have not enough cma_areas, memory will leak.
> I think that we need separate function to check constraint and this
> function should be called before reserving memory in
> cma_declare_contiguous().

Well, I will leave this check to avoid memory leak then.

> BTW, this mail doesn't appear in LKML. What happens? :)

I have no idea, I will send second version then.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

