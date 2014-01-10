Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbaAJPPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 10:15:14 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:49156 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaAJPPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 10:15:11 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-cc-52d00e7d1d9c
Message-id: <52D00E76.8060001@samsung.com>
Date: Fri, 10 Jan 2014 16:15:02 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/8 v3] crypto:s5p-sss: Use platform_get_irq() instead of
 _byname()
References: <1389095509-14357-2-git-send-email-ch.naveen@samsung.com>
 <1389354102-31709-1-git-send-email-ch.naveen@samsung.com>
In-reply-to: <1389354102-31709-1-git-send-email-ch.naveen@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t/xq7q1fBeCDK5sUbO4+/wwo8XLQ5oW
	c863sFh0v5KxuH/vJ5PF5V1z2CxmnN/HZLFo239mi1W7/jBanJ1ziMmBy2PLyptMHjtn3WX3
	2HZA1aNvyypGj8+b5AJYo7hsUlJzMstSi/TtErgy5nf8Zivo5ajYNPMxYwPjdbYuRk4OCQET
	iddP+tghbDGJC/fWA8W5OIQEljJK7Jr+lBUkISTwmVHi9x+DLkYODl4BLYkf1/xBwiwCqhLt
	K/ezgNhsAmoSnxsegc0UFYiQ+DtvPSOIzSsgKPFj8j2wGhGBcol/N9aAzWcWOMoo8XnORSaQ
	hLBApMSUqfNZIRY3MkpM27eCGSTBKeAm8e3+W7BJzALWEisnbYOy5SU2r3nLPIFRYBaSJbOQ
	lM1CUraAkXkVo2hqaXJBcVJ6rpFecWJucWleul5yfu4mRkj4f93BuPSY1SFGAQ5GJR7eglnn
	g4RYE8uKK3MPMUpwMCuJ8Nq/AgrxpiRWVqUW5ccXleakFh9iZOLglGpgPDN/4rdNpjun1Bhm
	s4ny/46VUNiad/9K9V9lHsfrjwql7C8/XTH1kuSvOV9/1S4XEji4YZ3fpquX5v+OsLkU15c6
	fe2+J72vE+d3ul36+T68ZunCXVcl2jaqVudbhZ8QO893Vna9BFPUyUMFZ85dzen4tsxhs8v/
	qPaNHKJuKsxmueU2ZpdOSCmxFGckGmoxFxUnAgBYfG+CXQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On 10.01.2014 12:41, Naveen Krishna Chatradhi wrote:
> From: Naveen Krishna Ch <ch.naveen@samsung.com>
>
> This patch uses the platform_get_irq() instead of the
> platform_get_irq_byname(). Making feeder control interrupt
> as resource "0" and hash interrupt as "1".
>
> reasons for this change.
> 1. Cannot find any Arch which is currently using this driver
> 2. Samsung Exynos4 and 5 SoCs only use the feeder control interrupt
> 3. Patches adding support for DT and H/W version are in pipeline
>
> Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: David S. Miller <davem@davemloft.net>
> CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
> TO: <linux-crypto@vger.kernel.org>
> CC: <linux-samsung-soc@vger.kernel.org>
> ---
> Changes since v2:
> None
>
>   drivers/crypto/s5p-sss.c |   24 ++++++++++++------------
>   1 file changed, 12 insertions(+), 12 deletions(-)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
