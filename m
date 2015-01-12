Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbbALJ26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:28:58 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:55006 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbbALJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:28:55 -0500
X-AuditID: cbfee68f-f791c6d000004834-ae-54b393d566fd
Message-id: <54B393F3.8070403@samsung.com>
Date: Mon, 12 Jan 2015 14:59:23 +0530
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robherring2@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>,
        =?windows-1252?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Thomas Abraham <thomas.ab@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v5 1/2] soc: samsung: add exynos chipid driver support
References: <1418285264-21763-1-git-send-email-pankaj.dubey@samsung.com>
 <CAL_JsqKaf+w_D-xLCUizuTmxwT7uUHExA=qMpawQ+00G7uMcBg@mail.gmail.com>
 <548A9D27.1000504@samsung.com> <1521226.qVx3V7aJT6@wuerfel>
In-reply-to: <1521226.qVx3V7aJT6@wuerfel>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsWyRsSkVvfq5M0hBi1TLCz+TjrGbnHgzw5G
	i/+PXrNa9C64ymYx5c9yJotNj6+xWlzeNYfNYsb5fUwWty/zWrTuPcJu8f3bNzaLjmWMFqt2
	/WF04PVoae5h8/j9axKjx85Zd9k9Nq3qZPO4c20Pm8fmJfUefVtWMXpsvzaP2ePzJrkAzigu
	m5TUnMyy1CJ9uwSujOXLzzIV9HBVNH2dwtbA2MvRxcjJISFgIjHjxAYWCFtM4sK99WwgtpDA
	UkaJA/vVYWr2/l0NVMMFFJ/OKDHt0mR2CKeVSWLB/SZmkCpeAS2Ju9vPMHYxcnCwCKhKfDyb
	CRJmE9CVePJ+LliJqECExIdVX9kgygUlfky+B7ZYREBRYuqLZ2A1zAL3WCTW7uUBsYUFvCRu
	bL7FCrHrLKPEzaWTmUASnAKaErOuNjBCNNhKLHi/jgXClpfYvOYtM0iDhMBUDol7xzvZQRIs
	AgIS3yYfYgE5TkJAVmLTAWaIzyQlDq64wTKBUWwWkptmIRk7C8nYBYzMqxhFUwuSC4qT0ouM
	9YoTc4tL89L1kvNzNzECo/r0v2f9OxjvHrA+xCjAwajEw2shtTlEiDWxrLgy9xCjKdAVE5ml
	RJPzgakjryTe0NjMyMLUxNTYyNzSTEmcd6HUz2AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFIN
	jMvy416+mzih+rvxvmna0cq1/pxJD3+77QhqECmuFjOar5Mi+z/ToqNbcGWd8iJWJ70zdyNC
	mLLWpx1jrb24WXby9bln7+w/9tbn64fIgv3vrvE7m5lw7PP4Hsj/xfVo1ea/xleiN6d+MXig
	xzL91drFLK9usbrJPRBb88Q0yq0z/+rv0+2By5VYijMSDbWYi4oTAVKslDPlAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jQd2rkzeHGDx/pGfxd9IxdosDf3Yw
	Wvx/9JrVonfBVTaLKX+WM1lsenyN1eLyrjlsFjPO72OyuH2Z16J17xF2i+/fvrFZdCxjtFi1
	6w+jA69HS3MPm8fvX5MYPXbOusvusWlVJ5vHnWt72Dw2L6n36NuyitFj+7V5zB6fN8kFcEY1
	MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAJ2tpFCW
	mFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcxYvvwsU0EPV0XT1ylsDYy9HF2M
	nBwSAiYSe/+uZoGwxSQu3FvP1sXIxSEkMJ1RYtqlyewQTiuTxIL7TcwgVbwCWhJ3t59h7GLk
	4GARUJX4eDYTJMwmoCvx5P1csBJRgQiJD6u+skGUC0r8mHwPbIGIgKLE1BfPwGqYBe6xSKzd
	ywNiCwt4SdzYfIsVYtdZRombSyczgSQ4BTQlZl1tYIRosJVY8H4dC4QtL7F5zVvmCYwCs5Ds
	mIWkbBaSsgWMzKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgpPGM+kdjKsaLA4xCnAwKvHw
	WkhtDhFiTSwrrsw9xCjBwawkwutaBhTiTUmsrEotyo8vKs1JLT7EaAoMgYnMUqLJ+cCEllcS
	b2hsYm5qbGppYmFiZqkkzqtk3xYiJJCeWJKanZpakFoE08fEwSnVwMg4w8VximGHmaDfLLHg
	3xZztq9cdZqlZUFQmJxe7+7IY46/fL5bM31bZ+yZXvS06t1xl7O9PUXFmdvE/lU9a9T6tDlQ
	8tKktXeL62JusCy5wPDidMSfnNf9Lz92p54v70qqeXC3cln0h6/Xla6rW02Senr0dGKiRR7j
	xevTHm/UDpL32n/6xgclluKMREMt5qLiRAAkrBJ6MAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Sorry for late reply.

On Friday 12 December 2014 05:01 PM, Arnd Bergmann wrote:
> On Friday 12 December 2014 13:15:43 Pankaj Dubey wrote:
>>>> +
>>>> +static void __iomem *exynos_chipid_base;
>>>> +
>>>> +struct exynos_chipid_info exynos_soc_info;
>>>> +EXPORT_SYMBOL(exynos_soc_info);
>>>
>>> The soc_device already has similar data.Why is this needed? Is it
>>> temporary for compatibility?
>>
>> struct soc_device_attribute can hold these two (product_id, and
>> revision) but they are defined as char * in soc_device_atttribute, and I
>> feel it's more specific for exposing via sysfs.
>> Also existing code in mach-exynos compares them via product_id/revision
>> macros, so I can say to keep compatibility.
>
> We had a similar discussion about the Marvell SoCs a while ago, and at
> the time we concluded that it would be best to create a platform-
> independent API to match the strings in soc_device_attribute against
> a list of strings in the driver, either by matching the start of the
> string, or using the glob_match() function. Would that work for you?
>

It might be useful, will you please point me to that discussion so that 
I can dig more and see how I can reuse it, or if required work on it.

Thanks,
Pankaj Dubey
> 	Arnd
>
