Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185AbaLJO1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:27:50 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:50259 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755670AbaLJO1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:27:49 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH 3/4] arm64: dts: Add mediatek MT8173 SoC and evaluation
 board dts and Makefile
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Eddie Huang <eddie.huang@mediatek.com>
CC: Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        <srv_heupstream@mediatek.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Olof Johansson <olof@lixom.net>,
        Robert Richter <rrichter@cavium.com>, Mark Brown <broonie@linaro.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <kernel@pengutronix.de>, <yh.chen@mediatek.com>
In-Reply-To: <1418208602-35584-4-git-send-email-eddie.huang@mediatek.com>
References: <1418208602-35584-1-git-send-email-eddie.huang@mediatek.com>
	 <1418208602-35584-4-git-send-email-eddie.huang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Dec 2014 22:27:42 +0800
Message-ID: <1418221662.21309.13.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wed, 2014-12-10 at 18:50 +0800, Eddie Huang wrote:
<...>
> diff --git a/arch/arm64/boot/dts/mt8173-evb.dts b/arch/arm64/boot/dts/mt8173-evb.dts
> new file mode 100644
> index 0000000..adf26dd
> --- /dev/null
> +++ b/arch/arm64/boot/dts/mt8173-evb.dts
<...>
> +	timer {
> +		compatible = "arm,armv8-timer";
> +		interrupt-parent = <&gic>;
> +		interrupts = <1 13 0x8>,
> +			     <1 14 0x8>,
> +			     <1 11 0x8>,
> +			     <1 10 0x8>;
> +		clock-frequency = <13000000>;

I believe our firmware doesn't need this line. Please remove it.

Joe.C


