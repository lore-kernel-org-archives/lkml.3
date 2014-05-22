Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbaEVQcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:32:35 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:38940 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaEVQcd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:32:33 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH v1 5/5] ARM: dts: qcom: Add APQ8084 serial port DT node
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1400775885-10296-6-git-send-email-gdjakov@mm-sol.com>
Date: Thu, 22 May 2014 11:32:28 -0500
Cc: mturquette@linaro.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, sboyd@codeaurora.org,
        rdunlap@infradead.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <693A0E52-34CF-4A63-A8D0-A83780F969F0@codeaurora.org>
References: <1400775885-10296-1-git-send-email-gdjakov@mm-sol.com> <1400775885-10296-6-git-send-email-gdjakov@mm-sol.com>
To: Georgi Djakov <gdjakov@mm-sol.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 22, 2014, at 11:24 AM, Georgi Djakov <gdjakov@mm-sol.com> wrote:

> Add the necessary DT node to probe the serial driver on
> APQ8084 platforms.
> 
> Signed-off-by: Georgi Djakov <gdjakov@mm-sol.com>
> ---
> arch/arm/boot/dts/qcom-apq8084.dtsi |    7 +++++++
> 1 file changed, 7 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/qcom-apq8084.dtsi b/arch/arm/boot/dts/qcom-apq8084.dtsi
> index 2dcd11e..c346549 100644
> --- a/arch/arm/boot/dts/qcom-apq8084.dtsi
> +++ b/arch/arm/boot/dts/qcom-apq8084.dtsi
> @@ -185,5 +185,12 @@
> 			reg = <0xfc400000 0x4000>;
> 		};
> 
> +		serial@f995e000 {

Mark it disabled in the soc.dtsi and “ok” in the board.

> +			compatible = "qcom,msm-uartdm-v1.4", "qcom,msm-uartdm";
> +			reg = <0xf995e000 0x1000>;
> +			interrupts = <0 114 0x0>;
> +			clocks = <&gcc GCC_BLSP2_UART2_APPS_CLK>, <&gcc GCC_BLSP2_AHB_CLK>;
> +			clock-names = "core", "iface";
> +		};
> 	};
> };
> -- 
> 1.7.9.5
> 

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

