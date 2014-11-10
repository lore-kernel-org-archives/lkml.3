Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbaKJKuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:50:50 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:35268 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbaKJKur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:50:47 -0500
Date: Mon, 10 Nov 2014 10:50:41 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, devicetree@vger.kernel.org
Subject: Re: [PATCH 01/13] ARM: STi: DT: STiH416: Add pinctl setup for usb
 controllers.
Message-ID: <20141110105041.GU21424@x1>
References: <1415361475-6218-1-git-send-email-peter.griffin@linaro.org>
 <1415361475-6218-2-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415361475-6218-2-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2014, Peter Griffin wrote:

> This patch adds the required pin config for all usb controllers
> on the stih416.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  arch/arm/boot/dts/stih416-pinctrl.dtsi | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/arch/arm/boot/dts/stih416-pinctrl.dtsi b/arch/arm/boot/dts/stih416-pinctrl.dtsi
> index c2025bc..9cccf2d 100644
> --- a/arch/arm/boot/dts/stih416-pinctrl.dtsi
> +++ b/arch/arm/boot/dts/stih416-pinctrl.dtsi
> @@ -147,6 +147,15 @@
>  				};
>  			};
>  
> +			usb {
> +				pinctrl_usb3: usb3 {
> +					st,pins {
> +						oc-detect = <&pio40 0 ALT1 IN>;
> +						pwr-enable = <&pio40 1 ALT1 OUT>;
> +					};
> +				};
> +			};
> +
>  			sbc_i2c1 {
>  				pinctrl_sbc_i2c1_default: sbc_i2c1-default {
>  					st,pins {
> @@ -318,6 +327,16 @@
>  				};
>  			};
>  
> +			usb {
> +				pinctrl_usb0: usb0 {
> +					st,pins {
> +						oc-detect = <&pio9 4 ALT1 IN>;
> +						pwr-enable = <&pio9 5 ALT1 OUT>;
> +					};
> +				};
> +			};
> +
> +
>  			i2c1 {
>  				pinctrl_i2c1_default: i2c1-default {
>  					st,pins {
> @@ -506,6 +525,21 @@
>  					};
>  				};
>  			};
> +
> +			usb {
> +				pinctrl_usb1: usb1 {
> +					st,pins {
> +						oc-detect = <&pio18 0 ALT1 IN>;
> +						pwr-enable = <&pio18 1 ALT1 OUT>;
> +					};
> +				};
> +				pinctrl_usb2: usb2 {
> +					st,pins {
> +						oc-detect = <&pio18 2 ALT1 IN>;
> +						pwr-enable = <&pio18 3 ALT1 OUT>;
> +					};
> +				};
> +			};
>  		};
>  
>  		pin-controller-fvdp-fe {

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
