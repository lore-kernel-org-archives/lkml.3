Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbaJFNFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 09:05:47 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:27929 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbaJFNFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 09:05:44 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-b7-543293a6fc81
Message-id: <543293A5.1090506@samsung.com>
Date: Mon, 06 Oct 2014 15:05:41 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Bolle <pebolle@tiscali.nl>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Valentin Rothberg <valentinrothberg@gmail.com>
Subject: Re: [PATCH 2/4] [media] exynos4-is: Remove optional dependency on
 PLAT_S5P
References: <1412586485.4054.40.camel@x220>
 <54328D18.2000606@cogentembedded.com>
In-reply-to: <54328D18.2000606@cogentembedded.com>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t/xq7rLJhuFGHRtErHoXXCVzeJs0xt2
	i02Pr7FaXN41h82iZ8NWVosZ5/cxWVxcJ2+x6NYZZoszq26xW3xqbmN24PJ4MPU/k8fOWXfZ
	PTYvqffo27KK0WPj9idMHp83yQWwRXHZpKTmZJalFunbJXBl3DtiWHCFtWLvl3NsDYy3WboY
	OTkkBEwkjs2dCmWLSVy4t56ti5GLQ0hgKaPE0n8rmSCcT4wSB2ZdZASp4hXQktixqpEdxGYR
	UJWY3vKLCcRmEzCU6D3aB1YjKhAhcfLuHnaIekGJH5PvsYAMEhFYzyix8PoHZhCHWeA5o8SZ
	myfBqoQFQiVu9+wEs4UEgiVa7t4Hu4lTwEji1/77QFM5gBr0JO5f1AIJMwvIS2xe85Z5AqPA
	LCQ7ZiFUzUJStYCReRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGSCR83cG49JjVIUYBDkYl
	Ht7IHYYhQqyJZcWVuYcYJTiYlUR4mYBxJMSbklhZlVqUH19UmpNafIiRiYNTqoFxRu+7uNl6
	TAoFYe1BrpHv5tUGhx17cjHv1uqmq7PrzI3XTTtwm8djgbZ7Gv/LRwuTxX72vXfbmnw02eFA
	X9EGvztFd3JFrRUfeIlVdRpt+bNktufmAofaQqtrikuO7f879Vrsxju117Y7LWG6IRBXafuI
	k2Xu44eOouvb5jQfqNPe8zl9cyuLEktxRqKhFnNRcSIAF5u0XGICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/14 14:37, Sergei Shtylyov wrote:
>> diff --git a/drivers/media/platform/exynos4-is/Kconfig b/drivers/media/platform/exynos4-is/Kconfig
>> index 77c951237744..775c3278d0eb 100644
>> --- a/drivers/media/platform/exynos4-is/Kconfig
>> +++ b/drivers/media/platform/exynos4-is/Kconfig
>> @@ -2,7 +2,7 @@
>>   config VIDEO_SAMSUNG_EXYNOS4_IS
>>   	bool "Samsung S5P/EXYNOS4 SoC series Camera Subsystem driver"
>>   	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
>> -	depends on (PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST)
>> +	depends on (ARCH_EXYNOS || COMPILE_TEST)
> 
>     Perhaps it's time to drop the useless parens?

Good point, let me prepare patches to clean that up.

--
Thanks,
Sylwester


