Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaEWEiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 00:38:20 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:52281 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaEWEiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 00:38:18 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-56-537ed0abbebe
Message-id: <537ED0AE.7040901@samsung.com>
Date: Fri, 23 May 2014 13:38:06 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Cc: linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Chris Ball <chris@printf.net>
Subject: Re: [PATCH RFC] mmc: add slot argument to mmc_of_parse
References: <1399457217-22846-1-git-send-email-ludovic.desroches@atmel.com>
 <CAPDyKFqeunnWmguTH89byNc5Yy+CBY4avMeeon3ZSfNMmGJa9Q@mail.gmail.com>
In-reply-to: <CAPDyKFqeunnWmguTH89byNc5Yy+CBY4avMeeon3ZSfNMmGJa9Q@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsWyRsSkQHf1hbpggwl7NSwmXN7OaLHp8TVW
	i8u75rBZHPnfz2hxaGayxfG14Q5sHgt+bWXxuHNtD5vH5iX1HjdeLWTy+LxJLoA1issmJTUn
	syy1SN8ugStj7+rX7AV90hV/dyxha2B8JtLFyMkhIWAi8WX9aRYIW0ziwr31bF2MXBxCAksZ
	JR5decsEUzTz1QlmiMR0Ronpe46zQjivgZyGG4wgVbwCWhLP5/9nBbFZBFQlTq/bDRZnE9CR
	2P7tONgkUYEwiaeb/7BB1AtK/Jh8D2g1B4eIQLTE4X8ZIGFmgTuMEt0PwGxhAXuJaQsWsEDs
	msQosXLJRrA5nALBEj+PHmGFaFCXmDRvETOELS+xec1bsEslBA6xS3xbdoAR4iABiW+TD4Et
	kxCQldh0gBniM0mJgytusExgFJuF5KRZSMbOQjJ2ASPzKkbR1ILkguKk9CJDveLE3OLSvHS9
	5PzcTYzASDv971nvDsbbB6wPMSYDrZzILCWanA+M1LySeENjMyMLUxNTYyNzSzPShJXEeZMe
	JgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYNyuEPLln1hO9sQKx3xnP02WkL+nN/YfXLYr
	YTbrTN3POd+uyx0NLZXuzKx+7ZHq7xZ8Xu/G5KhFv67XvWWZGmChzXTv55WH7pbRpo7hmmk3
	ghuq1r3tWjf73r+KjTN16+3m3l3GIC1j+T0z88vk8gPTTmiufCsW2fY2bLn23J3nSqwmBzm1
	ximxFGckGmoxFxUnAgB86/7VygIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t9jQd3VF+qCDS7tU7SYcHk7o8Wmx9dY
	LS7vmsNmceR/P6PFoZnJFsfXhjuweSz4tZXF4861PWwem5fUe9x4tZDJ4/MmuQDWqAZGm4zU
	xJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg/UoKZYk5pUCh
	gMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjL2rX7MX9ElX/N2xhK2B8ZlIFyMnh4SA
	icTMVyeYIWwxiQv31rN1MXJxCAlMZ5SYvuc4K4TzGshpuMEIUsUroCXxfP5/VhCbRUBV4vS6
	3WBxNgEdie3fjjOB2KICYRJPN/9hg6gXlPgx+R5LFyMHh4hAtMThfxkgYWaBO4wS3Q/AbGEB
	e4lpCxawQOyaxCixcslGsDmcAsESP48eYYVoUJeYNG8RM4QtL7F5zVvmCYwCs5CsmIWkbBaS
	sgWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxguP4mfQOxlUNFocYBTgYlXh4HzDVBQux
	JpYVV+YeYpTgYFYS4fUJBQrxpiRWVqUW5ccXleakFh9iTAaGwERmKdHkfGCKySuJNzQ2MTOy
	NDI3tDAyNidNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGxv41iiWHeDfyHZO6L28gZjHz
	coheXHKK6IyYqVd+7krayCKxQHNij9ubE+fY1l81iJk21yK28cfiq6q250v39k+/Uxg4x/hw
	wuv1PWZpy9d/mH1adZXZ772b3rw2N+aco7SW6ar2y5d10y4L6rSe6TQXUa/fNi0zzdAiM37/
	avn1gTuFdG1bBJRYijMSDbWYi4oTAUjp4a8nAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All.

This patch is working on progress?
I want to merge this patch for fixing dw-mmc controller problem.

If this patch didn't work on progress, i will send the patch based-on this patch.

Best Regards,
Jaehoon Chung

On 05/14/2014 06:53 PM, Ulf Hansson wrote:
> On 7 May 2014 12:06, Ludovic Desroches <ludovic.desroches@atmel.com> wrote:
>> Some hosts manage several slots. In these case information such as the bus
>> width, chip detect and others are into the slot node. So we have to parse
>> child nodes. If not NULL, slot node will be used instead of the device
>> node.
>>
>> Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
>> ---
>>
>> Hi,
>>
>> Since this patch is only a RFC, I have not yet updated drivers using this
>> function.
>>
>> I would like to use mmc_of_parse to reduce code duplication. My issue is that
>> atmel mci is a bit different from others mci host since it can provide
>> several slots, so it allocates several mmc hosts. By the way, it is not the
>> only one.
>>
>> When calling mmc_alloc_host, host->parent is set to &pdev->dev. mmc_of_parse
>> uses host->parent->of_node but in my case settings are in the slot nodes so in
>> the child nodes. That's why I would like to have a way to tell which node I
>> want to use.
> 
> Seems reasonable, thanks for working on this!
> 
>>
>>
>> Regards
>>
>> Ludovic
>>
>>
>>
>>  drivers/mmc/core/host.c |    9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
>> index fdea825..ed6cea5 100644
>> --- a/drivers/mmc/core/host.c
>> +++ b/drivers/mmc/core/host.c
>> @@ -300,13 +300,15 @@ static inline void mmc_host_clk_sysfs_init(struct mmc_host *host)
>>  /**
>>   *     mmc_of_parse() - parse host's device-tree node
>>   *     @host: host whose node should be parsed.
>> + *     @slot: some devices provide several slots so the node to parse
>> + *     is not the host one.
>>   *
>>   * To keep the rest of the MMC subsystem unaware of whether DT has been
>>   * used to to instantiate and configure this host instance or not, we
>>   * parse the properties and set respective generic mmc-host flags and
>>   * parameters.
>>   */
>> -int mmc_of_parse(struct mmc_host *host)
>> +int mmc_of_parse(struct mmc_host *host, struct device_node *slot)
>>  {
>>         struct device_node *np;
>>         u32 bus_width;
>> @@ -317,7 +319,10 @@ int mmc_of_parse(struct mmc_host *host)
>>         if (!host->parent || !host->parent->of_node)
>>                 return 0;
>>
>> -       np = host->parent->of_node;
>> +       if (slot)
>> +               np = slot;
>> +       else
>> +               np = host->parent->of_node;
>>
>>         /* "bus-width" is translated to MMC_CAP_*_BIT_DATA flags */
>>         if (of_property_read_u32(np, "bus-width", &bus_width) < 0) {
>> --
>> 1.7.9.5
>>
> 
> How about adding a new API, __mmc_of_parse((struct mmc_host *host,
> struct device_node *slot)
> Then let the old API mmc_of_parse() remain as is, but let it call the
> new API with slot == NULL.
> 
> Atmel can then use the new API, but the other drivers can remain as is.
> 
> Kind regards
> Ulf Hansson
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

