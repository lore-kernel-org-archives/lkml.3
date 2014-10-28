Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbaJ1A0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 20:26:45 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:40952 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbaJ1A0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 20:26:43 -0400
Date: Mon, 27 Oct 2014 17:26:38 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Caesar Wang <caesar.wang@rock-chips.com>
Cc: heiko@sntech.de, rui.zhang@intel.com, edubezval@gmail.com,
        zyf@rock-chips.com, dianders@chromium.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        cf@rock-chips.com, dbasehore@chromium.org, huangtao@rock-chips.com,
        cjf@rock-chips.com, zhengsq@rock-chips.com
Subject: Re: [PATCH v14 5/5] ARM: dts: enable Thermal on rk3288-evb board
Message-ID: <20141028002638.GI7594@dtor-ws>
References: <1414377588-2237-1-git-send-email-caesar.wang@rock-chips.com>
 <1414377588-2237-6-git-send-email-caesar.wang@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414377588-2237-6-git-send-email-caesar.wang@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 10:39:48AM +0800, Caesar Wang wrote:
> when a thermal temperature over TSHUT.Default to via
> CRU reset the entire chip on rk3288-evb Board,
> TSHUT is low active on rk3288-evb board.
> 
> Signed-off-by: Caesar Wang <caesar.wang@rock-chips.com>

Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

> ---
>  arch/arm/boot/dts/rk3288-evb.dtsi | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/rk3288-evb.dtsi b/arch/arm/boot/dts/rk3288-evb.dtsi
> index cb83cea..fb70523 100644
> --- a/arch/arm/boot/dts/rk3288-evb.dtsi
> +++ b/arch/arm/boot/dts/rk3288-evb.dtsi
> @@ -148,6 +148,12 @@
>  	status = "okay";
>  };
>  
> +&tsadc {
> +	tsadc-tshut-mode = <0>; /* tshut mode 0:CRU 1:GPIO */
> +	tsadc-tshut-polarity = <0>; /* tshut polarity 0:LOW 1:HIGH */
> +	status = "okay";
> +};
> +
>  &pinctrl {
>  	backlight {
>  		bl_en: bl-en {
> -- 
> 1.9.1
> 
> 

-- 
Dmitry
