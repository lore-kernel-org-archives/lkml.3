Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758402Ab3DQKsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 06:48:17 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:19002 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758015Ab3DQKsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 06:48:16 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f4c6d0000018de-7e-516e7dee668d
Message-id: <516E7DED.8090905@samsung.com>
Date: Wed, 17 Apr 2013 12:48:13 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
To: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>
Cc: linus.walleij@linaro.org, grant.likely@secretlab.ca,
        kyungmin.park@samsung.com, kgene.kim@samsung.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: Re: [PATCH 1/2] gpio: samsung: Remove OF support for s3c24xx
References: <1366134094-23140-1-git-send-email-s.nawrocki@samsung.com>
 <201304162013.45134.heiko@sntech.de>
In-reply-to: <201304162013.45134.heiko@sntech.de>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t/xa7rvavMCDY5cE7M4MPshq8WrMxvZ
	LP4/es1q0bvgKpvF2aY37BZT/ixnsri8aw6bxbEZSxgdODzuXNvD5nF+xkJGj74tqxg9fr7U
	8dh+bR6zx+dNcgFsUVw2Kak5mWWpRfp2CVwZU1eoFPzjrnj9bhVjA+N1zi5GTg4JAROJtRu3
	MkPYYhIX7q1n62Lk4hASWMoosftfAxtIgldAUOLH5HssXYwcHMwC8hJHLmWDhJkF1CUmzVvE
	DFH/iVGibeZnFoh6LYnv846D2SwCqhJHnjxkBLHZBAwleo/2gdmiAgESi5ecYwexRQTMJCYe
	mwM2iFngHqNEf8dOsIuEBVwlLp0/xQpiCwnkSixp/AI2lBNo0JQF/9kmMArMQnLfLIT7ZiG5
	bwEj8ypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkKD/soNx8TGrQ4wCHIxKPLwXCnIDhVgT
	y4orcw8xSnAwK4nwzg/JCxTiTUmsrEotyo8vKs1JLT7EyMTBKdXAyHLn+/F08QXW8scbtvN5
	nwkMdA+53rLzxbZ9UW6TT+ZrTn4of/7Ny5d/d/rXFR81PdrCIV9QvuDIiz77+U/XBOfdmtrr
	tkXmr+KattteGQs1UjwW7iwUndKyzkP0k6R92ck1zz59ue8rsCv6TVegiWtty/Ye+RsJh/x2
	bY5hE/7P+d9UWE5NX4mlOCPRUIu5qDgRAIXrdc9YAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2013 08:13 PM, Heiko Stübner wrote:
> Am Dienstag, 16. April 2013, 19:41:34 schrieb Sylwester Nawrocki:
>> There is no users of this code and there is already a pinctrl
>> driver written for s3c24xx which is going to be used on any
>> s3c24xx DT platforms. Hence this has been effectively a dead
>> code in mainline.
>>
>> This reverts commit 172c6a13653ac8cd6a231293b87c93821e90c1d6
>> gpio: samsung: add devicetree init for s3c24xx arches
>>
>> Cc: Heiko Stübner <heiko@sntech.de>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> This patch stems from a time where I thought pinctrl on s3c24xx would be ages 
> away :-D, so

Heh, I just thought I would clean this up a bit. And now we have
a nice pinctrl driver for s3c24xx. 

As a side note, I've tried it on s3c2440, together with your patch 
series adding dt support for s3c2416. Need to resolve a couple more
issues and hopefully will have a booting system soon.

> Acked-by: Heiko Stuebner <heiko@sntech.de>

Thanks.

I abstained with posting the second patch, which removes Exynos4/5 OF 
support from the gpio-samsung driver. Now when those platforms have 
proper pinctrl driver it is not possible to support simultaneously 
the old (pre-eliminary) DT bindings and the standard GPIO bindings 
implemented by the pinctrl driver. Anyway I have it prepared so I'll
post it, at least it might be a starting point for a discussion.


Thanks,
Sylwester

