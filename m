Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbaKJKHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:07:07 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:33459 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbaKJKHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:07:04 -0500
Date: Mon, 10 Nov 2014 10:06:58 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, devicetree@vger.kernel.org
Subject: Re: [PATCH 09/13] ARM: STi: DT: STiH410:  Add pinctl config for usb
 controllers.
Message-ID: <20141110100658.GN21424@x1>
References: <1415361475-6218-1-git-send-email-peter.griffin@linaro.org>
 <1415361475-6218-10-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415361475-6218-10-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Nov 2014, Peter Griffin wrote:

> This patch adds the required pin configiguration for the extra usb
> controllers found on the stih410 device.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  arch/arm/boot/dts/stih407-pinctrl.dtsi | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/arch/arm/boot/dts/stih407-pinctrl.dtsi b/arch/arm/boot/dts/stih407-pinctrl.dtsi
> index 402844c..fdaad5d 100644
> --- a/arch/arm/boot/dts/stih407-pinctrl.dtsi
> +++ b/arch/arm/boot/dts/stih407-pinctrl.dtsi
> @@ -539,6 +539,24 @@
>  				};
>  			};
>  
> +			usb0 {
> +				pinctrl_usb0: usb2-0 {
> +					st,pins {
> +						usb-oc-detect = <&pio35 0 ALT1 IN>;
> +						usb-pwr-enable = <&pio35 1 ALT1 OUT>;
> +					};
> +				};
> +			};
> +
> +			usb1 {
> +				pinctrl_usb1: usb2-1 {
> +					st,pins {
> +						usb-oc-detect = <&pio35 2 ALT1 IN>;
> +						usb-pwr-enable = <&pio35 3 ALT1 OUT>;
> +					};
> +				};
> +			};
> +
>  			usb3 {
>  				pinctrl_usb3: usb3-2 {
>  					st,pins {

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
