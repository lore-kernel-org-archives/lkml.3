Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbaCKMVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:21:39 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:13273 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbaCKMVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:21:36 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-f2-531effcb6eb3
Message-id: <531EFFBD.8050301@samsung.com>
Date: Tue, 11 Mar 2014 13:21:17 +0100
From: Tomasz Figa <t.figa@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, kgene.kim@samsung.com
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, linux@arm.linux.org.uk
Subject: Re: [PATCH 2/5] ARM: dts: exynos4x12: Add PMU dt data to support
 PMU(Perforamnce Monitoring Unit)
References: <1394524494-30641-1-git-send-email-cw00.choi@samsung.com>
 <1394524494-30641-3-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1394524494-30641-3-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xa7qn/8sFG2zYrmxx/ctzVov5R86x
	Wpx7tZLRonfBVTaLs01v2C02Pb7GanF51xw2ixnn9zFZ3L7Ma7H0+kUmiwnT17JYHF5xgMni
	1cE2FgdejzXz1jB6tDT3sHks+HyF3WPl8i9sHpuX1Hv0bVnF6PF5k5zHxrmhARxRXDYpqTmZ
	ZalF+nYJXBknNj9iKjjDVnHkslkD40LWLkZODgkBE4kZz06yQNhiEhfurWcDsYUEljJKvFgs
	2cXIBWR/ZpSY82s5O0iCV0BLYuqiFmYQm0VAVeLc/WdgDWwCahKfGx6B2aICERJ/561nhKgX
	lPgx+R7YAhEBe4k9DzYwggxlFtjJJLFn6U4mkISwQI7E2+9r2CG2NTJKLHz/EGwSp4CbxMp9
	v8BOZRawllg5aRsjhC0vsXnNW+YJjAKzkCyZhaRsFpKyBYzMqxhFU0uTC4qT0nON9IoTc4tL
	89L1kvNzNzFCYufrDsalx6wOMQpwMCrx8Ab4ygULsSaWFVfmHmKU4GBWEuG9eA8oxJuSWFmV
	WpQfX1Sak1p8iJGJg1OqgdFK86qroMT7Yq8N+8+Hfri+dteGc34Gd2ZHP5Q+FHgq9m9ve+jL
	3LN2ty4E/zW/divCUYBpRhuvW4PJLZbSyXfUJF2Vu7cyNCVL8HVqTPbnipP7Hm6tomeSYfj3
	6s6J4u9SRflnPP3u+Cd5knf+sY4K7gmOxQ2pC3bLsx9j9Z6bM73rxY7nR5VYijMSDbWYi4oT
	AQN8YwZ7AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On 11.03.2014 08:54, Chanwoo Choi wrote:
> ARM CPU has its own performance profiling unit(PMU, Perforamnce Monitoring Unit).
> This patch add PMU dt data to support PMU which count cache hit and miss events.
>
> PMU interrput list of Exynos4212
> - <2 2> : INTG2[2] - PMUIRQ[0] for CPU0
> - <3 2> : INTG3[2] - PMUIRQ[1] for CPU1
>
> PMU interrput list of Exynos4412
> - <2 2> : INTG2[2], PMUIRQ[0] for CPU0
> - <3 2> : INTG3[2], PMUIRQ[1] for CPU1
> - <18 2> : INTG18[2], PMUIRQ[2] : CPU2
> - <19 2> : INTG19[2], PMUIRQ[3] : CPU3
>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>   arch/arm/boot/dts/exynos4x12.dtsi | 6 ++++++
>   1 file changed, 6 insertions(+)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
