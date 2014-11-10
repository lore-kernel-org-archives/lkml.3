Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaKJKEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:04:15 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:46715 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbaKJKEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:04:12 -0500
Date: Mon, 10 Nov 2014 10:04:06 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, devicetree@vger.kernel.org
Subject: Re: [PATCH 13/13] ARM: STi: DT: STih407: Add clk_ignore_unused to
 kernel bootargs
Message-ID: <20141110100406.GL21424@x1>
References: <1415361475-6218-1-git-send-email-peter.griffin@linaro.org>
 <1415361475-6218-14-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415361475-6218-14-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2014, Peter Griffin wrote:

> At the moment we don't take a reference on some core interconnect
> clocks which means when CCF turns off unused clocks the SoC will
> hang. As a temp soltuion we will boot with clk_ignore_unused
> parameter for all b2120 boards.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  arch/arm/boot/dts/stihxxx-b2120.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/stihxxx-b2120.dtsi b/arch/arm/boot/dts/stihxxx-b2120.dtsi
> index 862bb2f..7280b6d 100644
> --- a/arch/arm/boot/dts/stihxxx-b2120.dtsi
> +++ b/arch/arm/boot/dts/stihxxx-b2120.dtsi
> @@ -8,7 +8,7 @@
>   */
>  / {
>  	chosen {
> -		bootargs = "console=ttyAS0,115200";
> +		bootargs = "console=ttyAS0,115200 clk_ignore_unused";

Acked-by: Lee Jones <lee.jones@linaro.org>

Although, hopefully we won't require this for too much longer.

>  		linux,stdout-path = &sbc_serial0;
>  	};
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
