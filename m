Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbaBFOmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 09:42:07 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:10026 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaBFOmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 09:42:04 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-c7-52f39f398863
Message-id: <52F39F36.30007@samsung.com>
Date: Thu, 06 Feb 2014 15:41:58 +0100
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
Subject: Re: [PATCH 4/9 v5] crypto:s5p-sss: Kconfig: Let Exynos SoCs select SSS
 driver
References: <1389243595-13207-1-git-send-email-ch.naveen@samsung.com>
 <1390987354-18665-1-git-send-email-ch.naveen@samsung.com>
In-reply-to: <1390987354-18665-1-git-send-email-ch.naveen@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t/xy7qW8z8HGfw6a2Zx9/lhRouXhzQt
	5pxvYbGYf+Qcq0X3KxmL+/d+Mllc3jWHzWLG+X1MFou2/We2ODvnEJMDl8eWlTeZPHbOusvu
	se2AqkffllWMHp83yQWwRnHZpKTmZJalFunbJXBl/D2cWPCBreLek6nMDYy3WbsYOTgkBEwk
	Dj1z7GLkBDLFJC7cW8/WxcjFISSwlFHi2rclTBDOZ0aJ9obNzCBVvAIaEr2T/7OBNLMIqEp0
	bw8ECbMJqEl8bnjEBmKLCkRI/J23nhGiXFDix+R7LCC2iEC5xL8ba8AWMAucYpSY3nQWrEEY
	qKHl4F+oZY2MEpOmvgJLcAq4SUz6NBXMZhawllg5aRsjhC0vsXnNW+YJjAKzkCyZhaRsFpKy
	BYzMqxhFU0uTC4qT0nMN9YoTc4tL89L1kvNzNzFCgv/LDsbFx6wOMQpwMCrx8G5Y/ylIiDWx
	rLgy9xCjBAezkghvatPnICHelMTKqtSi/Pii0pzU4kOMTBycUg2MMdHsf8LzX3+fnn180S4/
	txt82tOOGs9KmR7WuOt6/urXAunVM9/quD5c8P3qifsTdT+ftxdc9vDk5gdLP66S6sx2erTz
	lM7/C4qLNvKvUg56sdfTqcj4oyIDL/Njbr4dm0TmK+0Qiul16jG3tzm3yVnd0/xUmS3b7kVn
	mkXmz3+u1OCS+JkhXYmlOCPRUIu5qDgRAG7sWu9cAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On 29.01.2014 10:22, Naveen Krishna Chatradhi wrote:
> From: Naveen Krishna Ch <ch.naveen@samsung.com>
>
> This patch modifies Kconfig such that ARCH_EXYNOS SoCs
> which includes (Exynos4210, Exynos5250 and Exynos5420)
> can also select Samsung SSS(Security SubSystem) driver.
>
> Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: David S. Miller <davem@davemloft.net>
> CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
> TO: <linux-crypto@vger.kernel.org>
> CC: <linux-samsung-soc@vger.kernel.org>
> ---
> Changes since v4:
> none
> Changes since v3:
> Modified description to use "Exynos" instead of individual SoC name
>   drivers/crypto/Kconfig |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
