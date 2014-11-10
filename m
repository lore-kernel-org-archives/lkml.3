Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbaKJKty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:49:54 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:63898 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaKJKtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:49:53 -0500
Date: Mon, 10 Nov 2014 10:49:47 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, devicetree@vger.kernel.org
Subject: Re: [PATCH 02/13] ARM: STi: DT: STiH416: Add DT node for the
 stih415/6 usb2 phy
Message-ID: <20141110104947.GT21424@x1>
References: <1415361475-6218-1-git-send-email-peter.griffin@linaro.org>
 <1415361475-6218-3-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415361475-6218-3-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2014, Peter Griffin wrote:

> This usb picophy is found on stih415/6 SoC.

Then shouldn't it live in stih41x.dtsi?

> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  arch/arm/boot/dts/stih416.dtsi | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/stih416.dtsi b/arch/arm/boot/dts/stih416.dtsi
> index 1137bdf..0f3019a 100644
> --- a/arch/arm/boot/dts/stih416.dtsi
> +++ b/arch/arm/boot/dts/stih416.dtsi
> @@ -316,5 +316,14 @@
>  
>  			status	        = "disabled";
>  		};
> +
> +		usb2_phy: usb2phy@0 {
> +			compatible = "st,stih416-usb-phy";
> +			#phy-cells = <0>;
> +			st,syscfg = <&syscfg_rear>;
> +			clocks = <&clk_sysin>;
> +			clock-names = "osc_phy";
> +

Remove this '\n'.

> +		};
>  	};
>  };

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
