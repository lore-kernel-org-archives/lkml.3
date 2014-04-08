Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837AbaDHVgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 17:36:38 -0400
Received: from ns.mm-sol.com ([37.157.136.199]:33142 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756174AbaDHVgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 17:36:33 -0400
Message-ID: <53446BDC.2050609@mm-sol.com>
Date: Wed, 09 Apr 2014 00:36:28 +0300
From: Stanimir Vabanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2] ARM: qcom: Add initial IPQ8064 SoC and AP148 device
 trees
References: <1396972276-11549-1-git-send-email-galak@codeaurora.org>
In-Reply-To: <1396972276-11549-1-git-send-email-galak@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kumar,

<snip>

> diff --git a/arch/arm/boot/dts/qcom-ipq8064-ap148.dts b/arch/arm/boot/dts/qcom-ipq8064-ap148.dts
> new file mode 100644
> index 0000000..5e6f456
> --- /dev/null
> +++ b/arch/arm/boot/dts/qcom-ipq8064-ap148.dts
> @@ -0,0 +1,12 @@
> +#include "qcom-ipq8064-v1.0.dtsi"
> +
> +/ {
> +	model = "Qualcomm IPQ8064/DB149";
> +	compatible = "qcom,ipq8064-db149", "qcom,ipq8064";

The patch subject saying AP148, and here AP149. Which is the wrong one?

> +
> +	soc {
> +		serial@16340000 {
> +			status = "ok";
> +		};
> +	};
> +};
> diff --git a/arch/arm/boot/dts/qcom-ipq8064-v1.0.dtsi b/arch/arm/boot/dts/qcom-ipq8064-v1.0.dtsi
> new file mode 100644
> index 0000000..7093b07
> --- /dev/null
> +++ b/arch/arm/boot/dts/qcom-ipq8064-v1.0.dtsi
> @@ -0,0 +1 @@
> +#include "qcom-ipq8064.dtsi"
> diff --git a/arch/arm/boot/dts/qcom-ipq8064.dtsi b/arch/arm/boot/dts/qcom-ipq8064.dtsi
> new file mode 100644
> index 0000000..8ca3b51
> --- /dev/null
> +++ b/arch/arm/boot/dts/qcom-ipq8064.dtsi

<snip>

> +
> +		intc: interrupt-controller@2000000 {
> +			compatible = "qcom,msm-qgic2";
> +			interrupt-controller;
> +			#interrupt-cells = <3>;
> +			reg = < 0x02000000 0x1000 >,
> +			      < 0x02002000 0x1000 >;

extra spaces around these numbers

regards,
Stan
