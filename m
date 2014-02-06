Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaBFOjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 09:39:53 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53844 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbaBFOju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 09:39:50 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-a9-52f39eb42af6
Message-id: <52F39EB0.4050702@samsung.com>
Date: Thu, 06 Feb 2014 15:39:44 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3/9 v5] crypto:s5p-sss: Add support for SSS module on Exynos
References: <1389243569-13161-1-git-send-email-ch.naveen@samsung.com>
 <1390987294-18628-1-git-send-email-ch.naveen@samsung.com>
In-reply-to: <1390987294-18628-1-git-send-email-ch.naveen@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t/xy7pb5n0OMlizmsni7vPDjBYvD2la
	zDnfwmIx/8g5VovuVzIW9+/9ZLK4vGsOm8WM8/uYLBZt+89scXbOISYHLo8tK28yeeycdZfd
	Y9sBVY++LasYPT5vkgtgjeKySUnNySxLLdK3S+DKOHJyGkvBHvaKj18vsDQw/mXtYuTkkBAw
	kZhx/BEjhC0mceHeerYuRi4OIYGljBIzF8yAcj4zSlxZ9YYdpIpXQEtiyy6IbhYBVYmHK6+B
	xdkE1CQ+NzxiA7FFBSIk/s5bzwhRLyjxY/I9FhBbRKBc4t+NNWBDmQVOMUpMbzoL1iAsECDx
	9d4zJohtjYwSN2fMBEpwcHAKuEk8O2QKUsMsYC2xctI2RghbXmLzmrfMExgFZiHZMQtJ2Swk
	ZQsYmVcxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525ihETA1x2MS49ZHWIU4GBU4uHdsP5TkBBr
	YllxZe4hRgkOZiUR3tSmz0FCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGPuLvz9ZebVrs/R+Le0Q
	h0uCO5fJ8J95tqPP+tit/Ql/LsmVPimZ/zN5xym+rTcN+8K8zH8sapt3/B+v9d/7B+JizA/W
	BH5dez23rW3yd6/7r480R6upGYh/NJ3yu/bNjzLWRYHb7DX2ZnvrtUud/W8d1VN9RIFn1aQp
	m8uYvXz+x0n4VV3lt1diKc5INNRiLipOBACMEjZbXgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On 29.01.2014 10:21, Naveen Krishna Chatradhi wrote:
> This patch adds new compatible and variant struct to support the SSS
> module on Exynos4 (Exynos4210), Exynos5 (Exynos5420 and Exynos5250)
> for which
> 1. AES register are at an offset of 0x200 and
> 2. hash interrupt is not available
>
> Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: David S. Miller <davem@davemloft.net>
> CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
> TO: <linux-crypto@vger.kernel.org>
> CC: <linux-samsung-soc@vger.kernel.org>
> ---
> Changes since v4:
> Fix rebase error because of the patch 2/9
>
>   .../devicetree/bindings/crypto/samsung-sss.txt     |   21 +++-
>   drivers/crypto/s5p-sss.c                           |  107 +++++++++++++++-----
>   2 files changed, 103 insertions(+), 25 deletions(-)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
