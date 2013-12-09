Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab3LIIES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:04:18 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:48464 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab3LIIEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:04:16 -0500
X-AuditID: cbfee690-b7f676d00000310d-ea-52a5797e1fae
From: Jingoo Han <jg1.han@samsung.com>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Cc: "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Joonyoung Shim'" <jy0922.shim@samsung.com>,
        linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <20131206100215.GA27763@core.coreip.homeip.net>
In-reply-to: <20131206100215.GA27763@core.coreip.homeip.net>
Subject: Re: [PATCH] Input: samsung-keypad - favor platform data if present
Date: Mon, 09 Dec 2013 17:04:14 +0900
Message-id: <001101cef4b5$4072b400$c1581c00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7yakPnOJWNMnQxQuSJUXrT3kCJ/wCSsuaw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t8zQ926yqVBBk9nWFkcXvSC0eLywkus
	Fi/uXWSxuPnpG6vF5V1z2CxO/ulltDg2YwmjA7vHzll32T3uXNvD5tG3ZRWjx+dNcgEsUVw2
	Kak5mWWpRfp2CVwZryb9ZC+YzlLR+EGggXEzcxcjJ4eEgInEpFOr2CBsMYkL99aD2UICyxgl
	djz3h6nZum8CO0R8EaPE3z6vLkYuIPsXo8SC7euZQBJsAmoSX74cBisSEfCTWD7tAjtIEbPA
	OUaJA6enM0J0W0t8PnEXrIFTwEairf8K2DZhAW+J7TuPg9WwCKhK/Pg7BayGV8BW4kjHN0YI
	W1Dix+R7LCA2s4CWxPqdx5kgbHmJzWveAn3DAXSpusSjv7oQNxhJPLg6mxWiRERi34t3jCD3
	SAg8Ypc4//kJG8QuAYlvkw+xQPTKSmw6AA0USYmDK26wTGCUmIVk8ywkm2ch2TwLyYoFjCyr
	GEVTC5ILipPSi0z0ihNzi0vz0vWS83M3MUIidsIOxnsHrA8xJgOtn8gsJZqcD4z4vJJ4Q2Mz
	IwtTE1NjI3NLM9KElcR51R4lBQkJpCeWpGanphakFsUXleakFh9iZOLglGpg7JF96v1OzPa4
	5gyli0fKDq3XvOCXXbbrTPjZX/yMy7NiLm4Vvy798p/HviX5s4y697r9eL8rtijD+K50emZJ
	ROKU3cGrDszYtflkTQzH9CuKS7NTn4c/NEoVOxcjoFqz6cqPJ7PnHm7NmVvWcOen3brfK9k9
	1/Q1HnRkPvJP9Msjzq//VotoHlZiKc5INNRiLipOBABvKoQQ7gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJKsWRmVeSWpSXmKPExsVy+t9jAd26yqVBBvO7zSwOL3rBaHF54SVW
	ixf3LrJY3Pz0jdXi8q45bBYn//QyWhybsYTRgd1j56y77B53ru1h8+jbsorR4/MmuQCWqAZG
	m4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygE5QUyhJz
	SoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGa8m/WQvmM5S0fhBoIFxM3MXIyeH
	hICJxNZ9E9ghbDGJC/fWs4HYQgKLGCX+9nl1MXIB2b8YJRZsX88EkmATUJP48uUwWIOIgJ/E
	8mkX2EGKmAXOMUocOD2dEaLbWuLzibtgDZwCNhJt/VfApgoLeEts33kcrIZFQFXix98pYDW8
	ArYSRzq+MULYghI/Jt9jAbGZBbQk1u88zgRhy0tsXvMW6GoOoEvVJR791YW4wUjiwdXZrBAl
	IhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYIT
	wjPpHYyrGiwOMQpwMCrx8K5gXRokxJpYVlyZe4hRgoNZSYTXPAooxJuSWFmVWpQfX1Sak1p8
	iDEZ6NGJzFKiyfnAZJVXEm9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1M
	HJxSDYztF+ylP226+2hRZWZL7QU18VvVa+7oXK6a81J2ZZ25LJNztcCNS8q2d9sLg12CTNM3
	vk1LEjqTceqwdoDrzP/CUTbGkoK3brQd5tD+sU5GTuH6uV/Cm9t2xu15a6sZHJFYNfHo/SjB
	pr9ClyqdciZYPTFa+yMuUCR93l9dnU0FE9qfS+7beEGJpTgj0VCLuag4EQCb+yDbTAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 06, 2013 7:02 PM, Dmitry Torokhov wrote:
> 
> We should be able to override firmware-provided parameters with in-kernel
> data, if needed. To that effect favor platform data, if present, over
> devicetree data.
> 
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>

It looks good.

Reviewed-by: Jingoo Han <jg1.han@samsung.com>

Best regards,
Jingoo Han

> ---
>  drivers/input/keyboard/samsung-keypad.c | 36 +++++++++++++++++++--------------
>  1 file changed, 21 insertions(+), 15 deletions(-)


