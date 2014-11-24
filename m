Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbaKXAYb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 19:24:31 -0500
Received: from gloria.sntech.de ([95.129.55.99]:49861 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbaKXAYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 19:24:30 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, dianders@chromium.org,
        Mike Turquette <mturquette@linaro.org>,
        Mark yao <mark.yao@rock-chips.com>,
        Kever Yang <kever.yang@rock-chips.com>
Subject: Re: [PATCH] clk: rockchip: rk3288 export i2s0_clkout for use in DT
Date: Mon, 24 Nov 2014 01:07:38 +0100
Message-ID: <2905614.GvjeQFvyvc@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1416381319-31117-1-git-send-email-sonnyrao@chromium.org>
References: <1416381319-31117-1-git-send-email-sonnyrao@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sonny,

Am Dienstag, 18. November 2014, 23:15:19 schrieb Sonny Rao:
> This exposes the clock that comes out of the i2s block which generally
> goes to the audio codec.
> 
> Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
> ---
>  drivers/clk/rockchip/clk-rk3288.c      | 3 ++-
>  include/dt-bindings/clock/rk3288-cru.h | 1 +
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 

[...]

> diff --git a/include/dt-bindings/clock/rk3288-cru.h
> b/include/dt-bindings/clock/rk3288-cru.h index 100a08c..4acc730 100644
> --- a/include/dt-bindings/clock/rk3288-cru.h
> +++ b/include/dt-bindings/clock/rk3288-cru.h
> @@ -71,6 +71,7 @@
>  #define SCLK_HDMI_CEC		110
>  #define SCLK_HEVC_CABAC		111
>  #define SCLK_HEVC_CORE		112
> +#define SCLK_I2S0_OUT           113
> 
>  #define DCLK_VOP0		190
>  #define DCLK_VOP1		191

just to get branches right, do you plan on sending a patch using this new 
clock-id in a devicetree file in time for 3.19 (i.e. during the next week).

If you plan on doing this, we'll need a 2-patch series like Alexandru did for 
the mmc phases [because we would need a shared branch between clk and dts 
branches]. If not the patch can stay as it is.


Thanks
Heiko
