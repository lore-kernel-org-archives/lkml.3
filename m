Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599AbaCQKA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 06:00:27 -0400
Received: from nasmtp01.atmel.com ([192.199.1.245]:61513 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932318AbaCQKAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 06:00:24 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Mar 2014 06:00:24 EDT
Message-ID: <5326C68A.50307@atmel.com>
Date: Mon, 17 Mar 2014 17:55:22 +0800
From: Bo Shen <voice.shen@atmel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, <nicolas.ferre@atmel.com>
CC: Boris BREZILLON <b.brezillon@overkiz.com>,
        Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Russell King" <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/8] ARM: at91/dt: add clock properties to the wm8904
 codec node
References: <1395049541-28128-1-git-send-email-voice.shen@atmel.com> <1395049541-28128-9-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1395049541-28128-9-git-send-email-voice.shen@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.168.5.13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2014 05:45 PM, Bo Shen wrote:
> From: Boris BREZILLON <b.brezillon@overkiz.com>
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> Signed-off-by: Bo Shen <voice.shen@atmel.com>

Oh, sorry for my SOB. Please remove it when apply.

> ---
>
>   arch/arm/boot/dts/sama5d3xmb.dtsi | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/arch/arm/boot/dts/sama5d3xmb.dtsi b/arch/arm/boot/dts/sama5d3xmb.dtsi
> index 306eef0..d9bb413 100644
> --- a/arch/arm/boot/dts/sama5d3xmb.dtsi
> +++ b/arch/arm/boot/dts/sama5d3xmb.dtsi
> @@ -163,6 +163,8 @@
>   		compatible = "atmel,asoc-wm8904";
>   		pinctrl-names = "default";
>   		pinctrl-0 = <&pinctrl_pck0_as_audio_mck>;
> +		clocks = <&pck0>;
> +		clock-names = "pck0";
>
>   		atmel,model = "wm8904 @ SAMA5D3EK";
>   		atmel,audio-routing =
>

Best Regards,
Bo Shen
