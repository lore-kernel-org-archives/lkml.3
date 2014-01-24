Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbaAXPgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 10:36:53 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:47182 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbaAXPgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 10:36:51 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-c3-52e288904aa1
Message-id: <52E28881.5080008@samsung.com>
Date: Fri, 24 Jan 2014 16:36:33 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH 6/8 v4] ARM: dts: exynos5250/5420: add dt node for sss
 module
References: <1389243640-13282-1-git-send-email-ch.naveen@samsung.com>
 <1389777397-15193-1-git-send-email-ch.naveen@samsung.com>
In-reply-to: <1389777397-15193-1-git-send-email-ch.naveen@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsVy+t/xK7oTOh4FGeztErC4+/wwo8XLQ5oW
	3a9kLHoXXGWzuH/vJ5PF5V1z2CxmnN/HZLFo239mi1W7/jBanJ1ziMmBy2PnrLvsHtsOqHr0
	bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXRuOUaSwF31kr9r4/x9rA+Iali5GTQ0LARKKp6xiU
	LSZx4d56ti5GLg4hgaWMEg1X+pghnM9AzoQzYFW8AloSe369YwWxWQRUJV5P/cYEYrMJqEl8
	bnjEBmKLCkRI/J23nhGiXlDix+R7YL0iAuUS/26sAdvALHCAUWLd9FNADgeHsECwxNIHhhDL
	Ghklzj/6CdbAKeAmMfX4RjCbWcBaYuWkbYwQtrzE5jVvmScwCsxCsmMWkrJZSMoWMDKvYhRN
	LU0uKE5KzzXSK07MLS7NS9dLzs/dxAgJ+687GJceszrEKMDBqMTD+yH4YZAQa2JZcWXuIUYJ
	DmYlEd6drY+ChHhTEiurUovy44tKc1KLDzEycXBKNTDOU3b+p9uzKs5d02jnx2MTFsRsunl9
	feOKCYaVDa+CBFKuGHKoh++Yu7L20/mV2ytqjoucmTWlyX5Fk+qU5Rez0x5+XsGX9NTdK0Mm
	gkfjTL7BqlZV2+aSJOa1157vSCyaUOBe80helH1C4i4tfX7l6e127A43esXkTaye3pslfyxb
	Y/L5u3JKLMUZiYZazEXFiQB6AZs0WQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Naveen,

On 15.01.2014 10:16, Naveen Krishna Chatradhi wrote:
> This patch adds the device tree node for SSS module
> found on Exynos5420 and Exynos5250
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> TO: <linux-samsung-soc@vger.kernel.org>
> CC: Kukjin Kim <kgene.kim@samsung.com>
> CC: <linux-crypto@vger.kernel.org>
> ---
> Changes since v3:
> 1. Modified the SSS clock ID as per dt-bindings for Exynos5250 in
>     samsung-clk.git tree.
>
>   arch/arm/boot/dts/exynos5250.dtsi |    8 ++++++++
>   arch/arm/boot/dts/exynos5420.dtsi |   10 ++++++++++
>   2 files changed, 18 insertions(+)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

