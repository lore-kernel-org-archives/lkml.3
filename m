Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895AbaFSEV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 00:21:27 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:54233 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbaFSEV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 00:21:26 -0400
MIME-Version: 1.0
In-Reply-To: <1403080802-2794-1-git-send-email-cw00.choi@samsung.com>
References: <1403080802-2794-1-git-send-email-cw00.choi@samsung.com>
Date: Thu, 19 Jun 2014 09:51:23 +0530
Message-ID: <CAJuA9aiYGXYYORkbB66ZJs3rTjAu4a7HcPhMSOZs_qUJyy_o7g@mail.gmail.com>
Subject: Re: [PATCHv2 0/3] cpufreq: Use cpufreq-cpu0 driver for Exynos3250
From: Thomas Abraham <ta.omasab@gmail.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 2:09 PM, Chanwoo Choi <cw00.choi@samsung.com> wrote:
> This patchset use cpufreq-cpu0 driver to support Exynos3250 cpufreq. So, this
> patchset is based on following patchset[1] by Thomas Abraham.
>  [1] http://www.spinics.net/lists/arm-kernel/msg339392.html
>
> Changes from v1:
> - Rebased on new patchset[1] by Thomas Abraham
> - Modify clk-cpu.c to support Exynos3250
> - Drop documentation patch on previous patchset[2]
>  [2] http://www.spinics.net/lists/cpufreq/msg10265.html
> - Add only operating-points for Exynos3250 without armclk-divider-table
>
> Chanwoo Choi (3):
>   clk: samsung: cpu: Add support for cpu clocks of Exynos3250
>   clk: samsung: exynos3250: Use cpu-clock provider type to support cpufreq
>   ARM: dts: Exynos: Add cpu clock table for Exynos3250
>
>  arch/arm/boot/dts/exynos3250.dtsi    | 15 +++++++++++++++
>  drivers/clk/samsung/clk-cpu.c        | 31 +++++++++++++++++++++++++++++++
>  drivers/clk/samsung/clk-exynos3250.c | 14 ++++++++++----
>  3 files changed, 56 insertions(+), 4 deletions(-)

Hi Chanwoo,

I have reviewed this series and it looks fine. If the cpu clock type
is merged without any further changes, please add
Reviewed-by: Thomas Abraham <thomas.ab@samsung.com>

Thanks,
Thomas.

>
> --
> 1.8.0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
