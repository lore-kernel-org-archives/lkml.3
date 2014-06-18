Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbaFRF4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 01:56:37 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16874 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756605AbaFRF4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 01:56:34 -0400
X-AuditID: cbfee691-b7f2f6d0000040c4-7f-53a12a10eb7c
Message-id: <53A12A0F.7040808@samsung.com>
Date: Wed, 18 Jun 2014 14:56:31 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Cc: jic23@kernel.org, My self <ch.naveen@samsung.com>, t.figa@samsung.com,
        Kukjin Kim <kgene.kim@samsung.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, sachin.kamat@linaro.org,
        linux-iio@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCHv4 1/4] iio: adc: exynos_adc: Add exynos_adc_ops structure
 to improve readability
References: <1403058061-24271-1-git-send-email-cw00.choi@samsung.com>
 <1403058061-24271-2-git-send-email-cw00.choi@samsung.com>
 <CAHfPSqDjthqrV0X_XXBRvQk8C-yzBmcMB91OS8gpj9Q-tyKfRQ@mail.gmail.com>
In-reply-to: <CAHfPSqDjthqrV0X_XXBRvQk8C-yzBmcMB91OS8gpj9Q-tyKfRQ@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42JZI2JSrCugtTDYYPIGDou7zw8zWsw/co7V
	ov/NQlaLc69WMlo8aFrFZNG74CqbxcK2JSwW8468Y7G4vGsOm8WM8/uYLJZev8hksWjbf2aL
	CdPXsli8vTOdxaJ17xF2i5N/ehkt1s94zeIg6LFm3hpGj8t9vUweO2fdZfdYufwLm8fmFVoe
	m1Z1snncubaHzaNvyypGj8+b5AI4o7hsUlJzMstSi/TtErgytq7/xVhwnqVi0bZL7A2Mj5m7
	GDk5JARMJFY+PM0CYYtJXLi3nq2LkYtDSGApo8TW/x/ZYYo+dnYzQiQWMUq83HmEFSQhJPCa
	UeJWE38XIwcHr4CWxNEF/iBhFgFViTcLL4ANZQMK739xgw3EFhUIk1g5/QpYnFdAUOLH5Htg
	toiAkcTMBwsZQWxmgavMEo8WgNULC6RJ/N93DWrvCUaJPb9fgzVwCgRLLG2/xALRoC4xad4i
	ZghbXmLzmrdQn+3gkGiYGw1xkIDEt8mHWEDulBCQldh0AKpEUuLgihssExjFZiE5aRaSqbOQ
	TF3AyLyKUTS1ILmgOCm9yFSvODG3uDQvXS85P3cTIzD+T/97NnEH4/0D1ocYk4FWTmSWEk3O
	B6aPvJJ4Q2MzIwtTE1NjI3NLM9KElcR50x8lBQkJpCeWpGanphakFsUXleakFh9iZOLglGpg
	ZA8Iy6uQ2Wrlc8crvOTV3Z1yk+ann0takPeNY2/6qiuFE67FRG9TiglRS/78edOmoyvLfjTM
	qO67kOlhdCb0/k1RzU0mMowPPjg9Xyp4TqJ6H9PNaYn6GsJs1U+yZljzrZhwdsYbWaG0EP7b
	n12eOex5FMocf0iP0fznFlO/AnEpF8VaXttTSizFGYmGWsxFxYkA4J5JyRUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsVy+t9jAV0BrYXBBrOYLO4+P8xoMf/IOVaL
	/jcLWS3OvVrJaPGgaRWTRe+Cq2wWC9uWsFjMO/KOxeLyrjlsFjPO72OyWHr9IpPFom3/mS0m
	TF/LYvH2znQWi9a9R9gtTv7pZbRYP+M1i4Ogx5p5axg9Lvf1MnnsnHWX3WPl8i9sHptXaHls
	WtXJ5nHn2h42j74tqxg9Pm+SC+CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0
	MFdSyEvMTbVVcvEJ0HXLzAH6RUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpI
	WMOYsXX9L8aC8ywVi7ZdYm9gfMzcxcjJISFgIvGxs5sRwhaTuHBvPVsXIxeHkMAiRomXO4+w
	giSEBF4zStxq4u9i5ODgFdCSOLrAHyTMIqAq8WbhBRYQmw0ovP/FDTYQW1QgTGLl9CtgcV4B
	QYkfk++B2SICRhIzHywE28UscJVZ4tECsHphgTSJ//uuMULsPcEosef3a7AGToFgiaXtl1gg
	GtQlJs1bxAxhy0tsXvOWeQKjwCwkO2YhKZuFpGwBI/MqRtHUguSC4qT0XEO94sTc4tK8dL3k
	/NxNjODk8kxqB+PKBotDjAIcjEo8vBy5C4KFWBPLiitzDzFKcDArifC+Z1oYLMSbklhZlVqU
	H19UmpNafIgxGRgEE5mlRJPzgYkvryTe0NjEzMjSyNzQwsjYnDRhJXHeA63WgUIC6Yklqdmp
	qQWpRTBbmDg4pRoYo2+Hack/za6NmFuyhMHSN+blsf8m9szMBtYmn+6xXds0m5f7j++evGWf
	/7i29GWwxl8N6SyOfK65Q+iw/q/duns+fA8PLnvzmltkwVLdg4ozM0s6Hz2aYrT+7IZ9oT/M
	tEOVv6qyzd63Lq3Ii2+LjYtL/N51h/fdUfh2a/2tu+IzrmWZFM5gVGIpzkg01GIuKk4EAI38
	9mByAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On 06/18/2014 02:27 PM, Naveen Krishna Ch wrote:
> Hello Chanwoo,
> 
> On 18 June 2014 07:50, Chanwoo Choi <cw00.choi@samsung.com> wrote:
>> This patchset add 'exynos_adc_ops' structure which includes some functions
>> to control ADC operation according to ADC version (v1 or v2).
>>
>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> This is a good piece of change, Thanks.
> 
> Reviewed-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>

Thanks for your review.

Best Regards,
Chanwoo Choi
