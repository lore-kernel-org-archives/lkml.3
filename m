Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbaEJDVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 23:21:40 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:56682 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaEJDVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 23:21:38 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-e9-536d9b40f803
Message-id: <536D9F88.9000505@samsung.com>
Date: Sat, 10 May 2014 12:39:52 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
MIME-version: 1.0
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, mturquette@linaro.org,
        t.figa@samsung.com, kgene.kim@samsung.com, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org
Subject: Re: [PATCH 0/4] Add framework to support clkout
References: <1399640410-30957-1-git-send-email-tushar.behera@linaro.org>
In-reply-to: <1399640410-30957-1-git-send-email-tushar.behera@linaro.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsVy+t8zI12H2bnBBqfXqFjMP3KO1aL/zUJW
	i3OvVjJa9C64ymax6fE1VovLu+awWcw4v4/JYun1i0wWTydcZLOYMH0ti0Xr3iPsFutnvGax
	aP+7l82B12PNvDWMHpf7epk8Vi7/wuaxaVUnm8eda3vYPDYvqffo27KK0ePzJrkAjigum5TU
	nMyy1CJ9uwSujH0tC1gKbkhUTPtt08A4SbiLkZNDQsBE4tDmqawQtpjEhXvr2boYOTiEBJYx
	SqxkhSmZ07efuYuRCyg8nVGiY+1fFgjnNaPE41VrGEGqeAW0JLY0TGcDsVkEVCUmTdzKDmKz
	CehKPHk/lxnEFhUIk9g0vY8Vol5Q4sfkeywgtoiAjsSDRXvBbGaBQ0wS3UtMQGxhAQuJKV82
	QR3kIfHzeRRImFPAU+Ls789MEOXWEisnbWOEsOUlNq95ywxx9EQOiX03lSHOEZD4NvkQC8gY
	CQFZiU0HoEokJQ6uuMEygVFsFpKDZiGZOgvJ1AWMzKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLz
	czcxQuJ4wg7GewesDzEmA62cyCwlmpwPTAN5JfGGxmZGFqYmpsZG5pZmpAkrifOqPUoKEhJI
	TyxJzU5NLUgtii8qzUktPsTIxMEp1cCY96LutPGzmQd7hN4myTap5UhXXzz34fY5qWtCVe99
	HN6eaQs8IhYUuXrBsSXe9dLv9y9R9gnOf8hhw7By7pfpX5b/Cthx+YKC1ok33S6pEkIrBUUX
	ae/ccHrFjUPNxhE5ujHH7sW/FthmflSUj3nbtaszxfjETO2K86Y7ty+rd5Dd7JfyTHGCEktx
	RqKhFnNRcSIAxMrtwvkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsVy+t9jQV2H2bnBBvOOy1nMP3KO1aL/zUJW
	i3OvVjJa9C64ymax6fE1VovLu+awWcw4v4/JYun1i0wWTydcZLOYMH0ti0Xr3iPsFutnvGax
	aP+7l82B12PNvDWMHpf7epk8Vi7/wuaxaVUnm8eda3vYPDYvqffo27KK0ePzJrkAjqgGRpuM
	1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoJuVFMoSc0qB
	QgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBn7WhawFNyQqJj226aBcZJwFyMnh4SA
	icScvv3MELaYxIV769m6GLk4hASmM0p0rP3LAuG8ZpR4vGoNI0gVr4CWxJaG6WwgNouAqsSk
	iVvZQWw2AV2JJ+/ngk0SFQiT2DS9jxWiXlDix+R7LCC2iICOxINFe8FsZoFDTBLdS0xAbGEB
	C4kpXzYBzeQAWuYh8fN5FEiYU8BT4uzvz0wQ5dYSKydtY4Sw5SU2r3nLPIFRYBaSDbOQlM1C
	UraAkXkVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnCqeCa1g3Flg8UhRgEORiUe3oK3OcFC
	rIllxZW5hxglOJiVRHi31+cGC/GmJFZWpRblxxeV5qQWH2JMBgbARGYp0eR8YBrLK4k3NDYx
	M7I0MrMwMjE3J01YSZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQbG5vMfBZNvfbiQnLKtbT7L
	sTmnLhd178g04AjZGfA757awRmXJvQd6D9yvx9QHPs9Stq04/W//fevvwlZcLWYvfXsnHVuQ
	fnKX14PYKytv23i6Mv0T1Lp4Kj3XInN5/mNOrWnmDrOtNFsCbvz/7GjAJi3RI57zONDsA8+S
	XT2ur1l9tmpa7gtRYinOSDTUYi4qTgQA0xNbPVkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tushar,

On 05/09/2014 10:00 PM, Tushar Behera wrote:
> The MUX/GATE register for XCLKOUT doesn't resides within PMU domain,
> this can be accessed through a regmap provided by syscon driver. Adding
> another clock provider to handle regmap based handing of XCLKOUT.
>
> Dependency:
> 1. [PATCH v3] mfd: syscon: Support early initialization
> http://article.gmane.org/gmane.linux.kernel/1679446
>
> Also we need to find a suitable place to call early_syscon_init(), after
> the device tree has been unflattened and before clock initialization.
>
> While testing, I called this before of_clk_init() in arch/arm/kernel/time.c,
> but that place is too generic. Calling anywhere from exynos.c is not
> working ATM.

IMO we do not need to, or if I am not wrong we should not change time.c.

It's possible if we have exynos specific init_time with following changes.
FYI, In my patch series for Exynos PMU [1], currently I am handling this in
exynos_dt_machine_init. But definitely it can be handled as below and it works
without any side effect and I have tested it. Only reason I do not adopted this
as for Exynos PMU patch support I had other options. But if required and if
following change is acceptable I can include this in my next version of Exynos
PMU patch series.

[1]: https://lkml.org/lkml/2014/4/30/18


+static void __init exynos_init_time(void)
+{
+    /* Nothing to do timer specific
+     * as early_syscon_init requires DT to be unflattened and
+     * system should be able to allocate memory we need to
+     * postpone until init_time, but it should be done before
+     * init_machine. Because before init_machine, secondary
+     * core boot starts and it uses PMU registers.
+     */
+
+    exynos_map_pmu();
+
+    of_clk_init(NULL);
+    clocksource_of_init();
+
+}
+
  DT_MACHINE_START(EXYNOS_DT, "SAMSUNG EXYNOS (Flattened Device Tree)")
      /* Maintainer: Thomas Abraham <thomas.abraham@linaro.org> */
      /* Maintainer: Kukjin Kim <kgene.kim@samsung.com> */
      .smp        = smp_ops(exynos_smp_ops),
      .map_io        = exynos_init_io,
      .init_early    = exynos_firmware_init,
+    .init_time    = exynos_init_time,

>
> Tushar Behera (4):
>    clk: samsung: out: Add infrastructure to register CLKOUT
>    clk: samsung: exynos5420: Add xclkout debug clock
>    clk: samsung: exynos5250: Add xclkout debug clock
>    ARM: dts: Add pmu-syscon handle for Exynos5420/Exynos5250 clock
>
>   arch/arm/boot/dts/exynos5250.dtsi      |    1 +
>   arch/arm/boot/dts/exynos5420.dtsi      |    1 +
>   drivers/clk/samsung/Makefile           |    2 +-
>   drivers/clk/samsung/clk-exynos5250.c   |   14 +++
>   drivers/clk/samsung/clk-exynos5420.c   |   14 +++
>   drivers/clk/samsung/clk-out.c          |  181 ++++++++++++++++++++++++++++++++
>   drivers/clk/samsung/clk.h              |   33 ++++++
>   include/dt-bindings/clock/exynos5250.h |    3 +
>   include/dt-bindings/clock/exynos5420.h |    5 +-
>   9 files changed, 252 insertions(+), 2 deletions(-)
>   create mode 100644 drivers/clk/samsung/clk-out.c
>


-- 
Best Regards,
Pankaj Dubey

