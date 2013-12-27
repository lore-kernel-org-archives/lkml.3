Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab3L0Ixj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 03:53:39 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:21316 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754025Ab3L0Ixi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 03:53:38 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(z579eh551biz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h17326ah8275bh8275dh1de097h186068hz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Fri, 27 Dec 2013 16:53:27 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
CC: <broonie@kernel.org>, <alsa-devel@alsa-project.org>,
        Jingchang Lu <b35083@freescale.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv4 2/4] ARM: dts: Add Freescale SAI ALSA SoC Digital Audio
 Interface node for VF610.
Message-ID: <20131227085322.GA3367@S2101-09.ap.freescale.net>
References: <1387501387-2151-1-git-send-email-Li.Xiubo@freescale.com>
 <1387501387-2151-2-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1387501387-2151-2-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 09:03:05AM +0800, Xiubo Li wrote:
> This patch adds the SAI's edma mux Tx and Rx support.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> Signed-off-by: Jingchang Lu <b35083@freescale.com>
> ---
>  arch/arm/boot/dts/vf610.dtsi | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
> index e84d84c..2d6ddd0 100644
> --- a/arch/arm/boot/dts/vf610.dtsi
> +++ b/arch/arm/boot/dts/vf610.dtsi
> @@ -166,6 +166,9 @@
>  				interrupts = <0 86 0x04>;
>  				clocks = <&clks VF610_CLK_SAI2>;
>  				clock-names = "sai";
> +				dma-names = "tx", "rx";
> +				dmas = <&edma0 0 VF610_EDMA_MUXID0_SAI2_TX>,
> +					<&edma0 0 VF610_EDMA_MUXID0_SAI2_RX>;

Where are these VF610_EDMA_MUXID0_* macros defined?  I cannot find them
in my tree.

Shawn

>  				status = "disabled";
>  			};
>  
> -- 
> 1.8.4
> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

