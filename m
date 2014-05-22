Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaEVPl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:41:56 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:49344 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbaEVPly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:41:54 -0400
Date: Thu, 22 May 2014 16:41:47 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        srinivas.kandagatla@gmail.com, chris@printf.net,
        ulf.hansson@linaro.org, kernel@stlinux.com, linux-mmc@vger.kernel.org,
        devicetree@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Subject: Re: [PATCH 6/8] ARM: STi: DT: Enable mmc0 for both stih415 and
 stih416 SoCs
Message-ID: <20140522154147.GE19747@lee--X1>
References: <1400771902-26553-1-git-send-email-peter.griffin@linaro.org>
 <1400771902-26553-7-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400771902-26553-7-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2014, Peter Griffin wrote:

> Because the first sdhci controller is present on both stih415 and
> stih416 SoC which can both populate the b2020 board, it can be
> enabled in the generic DT file.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> Signed-off-by: Giuseppe Cavallaro <peppe.cavallaro@st.com>

These are the wrong way around.

You can correct that when adding my:

  Acked-by: Lee Jones <lee.jones@linaro.org>

> ---
>  arch/arm/boot/dts/stih41x-b2020x.dtsi | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/stih41x-b2020x.dtsi b/arch/arm/boot/dts/stih41x-b2020x.dtsi
> index df01c12..f797a06 100644
> --- a/arch/arm/boot/dts/stih41x-b2020x.dtsi
> +++ b/arch/arm/boot/dts/stih41x-b2020x.dtsi
> @@ -8,6 +8,10 @@
>   */
>  / {
>  	soc {
> +		mmc0: sdhci@fe81e000 {
> +			status = "okay";
> +		};
> +
>  		spifsm: spifsm@fe902000 {
>  			#address-cells = <1>;
>  			#size-cells    = <1>;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
