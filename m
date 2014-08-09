Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaHIPde (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 11:33:34 -0400
Received: from gloria.sntech.de ([95.129.55.99]:51199 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbaHIPdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 11:33:32 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Sonny Rao <sonnyrao@chromium.org>,
        eddie.cai@rock-chips.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pinctrl: Add mux options 3 and 4 for rockchip pinctrl
Date: Sat, 09 Aug 2014 17:34:45 +0200
Message-ID: <10830677.MYpxgOr8EG@diego>
User-Agent: KMail/4.12.4 (Linux/3.13-1-amd64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1407536949-31323-1-git-send-email-dianders@chromium.org>
References: <1407536949-31323-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 8. August 2014, 15:29:09 schrieb Doug Anderson:
> Newer Rockchip SoCs have more muxing slots.  Add slots 3 and 4 since
> the rk3288 table goes all the way up to 4.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>

Reviewed-by: Heiko Stuebner <heiko@sntech.de>


> ---
>  Documentation/devicetree/bindings/pinctrl/rockchip,pinctrl.txt | 6 +++---
>  include/dt-bindings/pinctrl/rockchip.h                         | 2 ++
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/pinctrl/rockchip,pinctrl.txt
> b/Documentation/devicetree/bindings/pinctrl/rockchip,pinctrl.txt index
> 4658b69..388b213 100644
> --- a/Documentation/devicetree/bindings/pinctrl/rockchip,pinctrl.txt
> +++ b/Documentation/devicetree/bindings/pinctrl/rockchip,pinctrl.txt
> @@ -2,8 +2,8 @@
> 
>  The Rockchip Pinmux Controller, enables the IC
>  to share one PAD to several functional blocks. The sharing is done by
> -multiplexing the PAD input/output signals. For each PAD there are up to
> -4 muxing options with option 0 being the use as a GPIO.
> +multiplexing the PAD input/output signals. For each PAD there are several
> +muxing options with option 0 being the use as a GPIO.
> 
>  Please refer to pinctrl-bindings.txt in this directory for details of the
>  common pinctrl bindings used by client devices, including the meaning of
> the @@ -58,7 +58,7 @@ Deprecated properties for gpio sub nodes:
>  Required properties for pin configuration node:
>    - rockchip,pins: 3 integers array, represents a group of pins mux and
> config setting. The format is rockchip,pins = <PIN_BANK PIN_BANK_IDX MUX
> &phandle>. -    The MUX 0 means gpio and MUX 1 to 3 mean the specific
> device function. +    The MUX 0 means gpio and MUX 1 to N mean the specific
> device function. The phandle of a node containing the generic pinconfig
> options to use, as described in pinctrl-bindings.txt in this directory.
> 
> diff --git a/include/dt-bindings/pinctrl/rockchip.h
> b/include/dt-bindings/pinctrl/rockchip.h index cd5788b..743e66a 100644
> --- a/include/dt-bindings/pinctrl/rockchip.h
> +++ b/include/dt-bindings/pinctrl/rockchip.h
> @@ -28,5 +28,7 @@
>  #define RK_FUNC_GPIO	0
>  #define RK_FUNC_1	1
>  #define RK_FUNC_2	2
> +#define RK_FUNC_3	3
> +#define RK_FUNC_4	4
> 
>  #endif

