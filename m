Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaKQTjJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:39:09 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:62386 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaKQTjH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:39:07 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Alexandru M Stan <amstan@chromium.org>, "Heiko Stuebner" <heiko@sntech.de>,
        "Doug Anderson" <dianders@chromium.org>,
        "addy ke" <addy.ke@rock-chips.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1416009604-31545-2-git-send-email-amstan@chromium.org>
Cc: "Sonny Rao" <sonnyrao@chromium.org>,
        "Kever Yang" <kever.yang@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        "Alexandru M Stan" <amstan@chromium.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        mark.yao@rock-chips.com, linux-kernel@vger.kernel.org
References: <1416009604-31545-1-git-send-email-amstan@chromium.org>
 <1416009604-31545-2-git-send-email-amstan@chromium.org>
Message-ID: <20141117193902.25314.97687@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v2 1/2] clk: rockchip: add bindings for the mmc clock phases
Date: Mon, 17 Nov 2014 11:39:02 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alexandru M Stan (2014-11-14 16:00:03)
> This will be used in a later patch for clock phase tuning.
> 
> Suggested-by: Heiko Stuebner <heiko@sntech.de>
> Signed-off-by: Alexandru M Stan <amstan@chromium.org>
> ---
> Changes in v2: None
> 
>  include/dt-bindings/clock/rk3288-cru.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/include/dt-bindings/clock/rk3288-cru.h b/include/dt-bindings/clock/rk3288-cru.h
> index 100a08c..465d0f6 100644
> --- a/include/dt-bindings/clock/rk3288-cru.h
> +++ b/include/dt-bindings/clock/rk3288-cru.h
> @@ -72,6 +72,16 @@
>  #define SCLK_HEVC_CABAC                111
>  #define SCLK_HEVC_CORE         112
>  
> +#define SCLK_SDMMC_DRV_PHASE   113
> +#define SCLK_SDIO0_DRV_PHASE   114
> +#define SCLK_SDIO1_DRV_PHASE   115
> +#define SCLK_EMMC_DRV_PHASE    116
> +
> +#define SCLK_SDMMC_SAMPLE_PHASE        117
> +#define SCLK_SDIO0_SAMPLE_PHASE        118
> +#define SCLK_SDIO1_SAMPLE_PHASE        119
> +#define SCLK_EMMC_SAMPLE_PHASE 120

It looks like you are adding new clocks to handle the phase requirement.
Is that the right thing to do? Don't these clks already exist (e.g.
SCLK_SDMMC)?

Regards,
Mike

> +
>  #define DCLK_VOP0              190
>  #define DCLK_VOP1              191
>  
> -- 
> 2.1.0.rc2.206.gedb03e5
> 
