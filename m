Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbaLUOPK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 09:15:10 -0500
Received: from gloria.sntech.de ([95.129.55.99]:43757 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765AbaLUOPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 09:15:08 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Dmitry Torokhov <dtor@chromium.org>
Cc: Mike Turquette <mturquette@linaro.org>, dianders@chromium.org,
        sonnyrao@chromium.org, addy.ke@rock-chips.com, hl@rock-chips.com,
        kever.yang@rock-chips.com, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] CHROMIUM: clk: rockchip: add clock IDs for the PVTM clocks
Date: Sun, 21 Dec 2014 15:14:53 +0100
Message-ID: <2752828.P8uvZNT2Jv@phil>
User-Agent: KMail/4.14.2 (Linux/3.16-3-amd64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <1418948026-3463-1-git-send-email-dtor@chromium.org>
References: <1418948026-3463-1-git-send-email-dtor@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

This looks ok and also like it's meant to go upstream, because it still has 
the CHROMIUM-prefix?

No need to resend, I remove them myself, just want to make sure here :-)


Heiko

Am Donnerstag, 18. Dezember 2014, 16:13:45 schrieb Dmitry Torokhov:
> From: Huang Lin <hl@rock-chips.com>
> 
> Process-Voltage-Temperature Monitor has two clocks, PVTM_CORE and
> PVTM_GPU.
> 
> Signed-off-by: Huang Lin <hl@rock-chips.com>
> Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
> ---
> 
> Note that I left a hole at 122 for SCLK_USBPHY480M_SRC which is floating
> around.
> 
>  include/dt-bindings/clock/rk3288-cru.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/dt-bindings/clock/rk3288-cru.h
> b/include/dt-bindings/clock/rk3288-cru.h index f60ce72..ba4c194 100644
> --- a/include/dt-bindings/clock/rk3288-cru.h
> +++ b/include/dt-bindings/clock/rk3288-cru.h
> @@ -81,6 +81,9 @@
>  #define SCLK_SDIO1_SAMPLE	120
>  #define SCLK_EMMC_SAMPLE	121
> 
> +#define SCLK_PVTM_CORE		123
> +#define SCLK_PVTM_GPU		124
> +
>  #define DCLK_VOP0		190
>  #define DCLK_VOP1		191

