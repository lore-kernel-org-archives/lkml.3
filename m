Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab3GCDxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 23:53:31 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:28248 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752680Ab3GCDxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 23:53:30 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -7
X-BigFish: VS-7(zzbb2dI98dI9371I1432I179dNc8kzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bh8275dhz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Message-ID: <51D3A030.4020608@freescale.com>
Date: Wed, 3 Jul 2013 11:53:20 +0800
From: Hongbo Zhang <hongbo.zhang@freescale.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: <hongbo.zhang@freescale.com>
CC: <vinod.koul@intel.com>, <djbw@fb.com>, <scottwood@freescale.com>,
        <vakul@freescale.com>, <leoLi@freescale.com>,
        <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 1/2] DMA: Freescale: Add new 8-channel DMA engine device
 tree nodes
References: <1372650378-2936-1-git-send-email-hongbo.zhang@freescale.com>
In-Reply-To: <1372650378-2936-1-git-send-email-hongbo.zhang@freescale.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hmm...add the devicetree-discuss@lists.ozlabs.org into list.

Note that we are discussing a better naming for this new compatible 
property in the corresponding [PATCH 2/2], so I will resend a v2 of this 
patch.


On 07/01/2013 11:46 AM, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>
> Freescale QorIQ T4 and B4 introduce new 8-channel DMA engines, this patch add
> the device tree nodes for them.
>
> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
> ---
>   arch/powerpc/boot/dts/fsl/qoriq-dma2-0.dtsi |   90 +++++++++++++++++++++++++++
>   arch/powerpc/boot/dts/fsl/qoriq-dma2-1.dtsi |   90 +++++++++++++++++++++++++++
>   arch/powerpc/boot/dts/fsl/t4240si-post.dtsi |    4 +-
>   3 files changed, 182 insertions(+), 2 deletions(-)
>   create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-dma2-0.dtsi
>   create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-dma2-1.dtsi
>
> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-dma2-0.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-dma2-0.dtsi
> new file mode 100644
> index 0000000..c626c49
> --- /dev/null
> +++ b/arch/powerpc/boot/dts/fsl/qoriq-dma2-0.dtsi
> @@ -0,0 +1,90 @@
> +/*
> + * QorIQ DMA device tree stub [ controller @ offset 0x100000 ]
> + *
> + * Copyright 2011-2013 Freescale Semiconductor Inc.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions are met:
> + *     * Redistributions of source code must retain the above copyright
> + *       notice, this list of conditions and the following disclaimer.
> + *     * Redistributions in binary form must reproduce the above copyright
> + *       notice, this list of conditions and the following disclaimer in the
> + *       documentation and/or other materials provided with the distribution.
> + *     * Neither the name of Freescale Semiconductor nor the
> + *       names of its contributors may be used to endorse or promote products
> + *       derived from this software without specific prior written permission.
> + *
> + *
> + * ALTERNATIVELY, this software may be distributed under the terms of the
> + * GNU General Public License ("GPL") as published by the Free Software
> + * Foundation, either version 2 of that License or (at your option) any
> + * later version.
> + *
> + * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
> + * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
> + * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
> + * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
> + * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
> + * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
> + * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
> + * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
> + * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> + */
> +
> +dma0: dma@100300 {
> +	#address-cells = <1>;
> +	#size-cells = <1>;
> +	compatible = "fsl,eloplus-dma2";
> +	reg = <0x100300 0x4 0x100600 0x4>;
> +	ranges = <0x0 0x100100 0x500>;
> +	cell-index = <0>;
> +	dma-channel@0 {
> +		compatible = "fsl,eloplus-dma-channel";
> +		reg = <0x0 0x80>;
> +		cell-index = <0>;
> +		interrupts = <28 2 0 0>;
> +	};
> +	dma-channel@80 {
> +		compatible = "fsl,eloplus-dma-channel";
> +		reg = <0x80 0x80>;
> +		cell-index = <1>;
> +		interrupts = <29 2 0 0>;
> +	};
> +	dma-channel@100 {
> +		compatible = "fsl,eloplus-dma-channel";
> +		reg = <0x100 0x80>;
> +		cell-index = <2>;
> +		interrupts = <30 2 0 0>;
> +	};
> +	dma-channel@180 {
> +		compatible = "fsl,eloplus-dma-channel";
> +		reg = <0x180 0x80>;
> +		cell-index = <3>;
> +		interrupts = <31 2 0 0>;
> +	};
> +	dma-channel@300 {
> +		compatible = "fsl,eloplus-dma-channel";
> +		reg = <0x300 0x80>;
> +		cell-index = <4>;
> +		interrupts = <76 2 0 0>;
> +	};
> +	dma-channel@380 {
> +		compatible = "fsl,eloplus-dma-channel";
> +		reg = <0x380 0x80>;
> +		cell-index = <5>;
> +		interrupts = <77 2 0 0>;
> +	};
> +	dma-channel@400 {
> +		compatible = "fsl,eloplus-dma-channel";
> +		reg = <0x400 0x80>;
> +		cell-index = <6>;
> +		interrupts = <78 2 0 0>;
> +	};
> +	dma-channel@480 {
> +		compatible = "fsl,eloplus-dma-channel";
> +		reg = <0x480 0x80>;
> +		cell-index = <7>;
> +		interrupts = <79 2 0 0>;
> +	};
> +};
> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-dma2-1.dtsi b/arch/powerpc/boot/dts/fsl/qoriq-dma2-1.dtsi
> new file mode 100644
> index 0000000..980ea77
> --- /dev/null
> +++ b/arch/powerpc/boot/dts/fsl/qoriq-dma2-1.dtsi
> @@ -0,0 +1,90 @@
> +/*
> + * QorIQ DMA device tree stub [ controller @ offset 0x101000 ]
> + *
> + * Copyright 2011-2013 Freescale Semiconductor Inc.
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions are met:
> + *     * Redistributions of source code must retain the above copyright
> + *       notice, this list of conditions and the following disclaimer.
> + *     * Redistributions in binary form must reproduce the above copyright
> + *       notice, this list of conditions and the following disclaimer in the
> + *       documentation and/or other materials provided with the distribution.
> + *     * Neither the name of Freescale Semiconductor nor the
> + *       names of its contributors may be used to endorse or promote products
> + *       derived from this software without specific prior written permission.
> + *
> + *
> + * ALTERNATIVELY, this software may be distributed under the terms of the
> + * GNU General Public License ("GPL") as published by the Free Software
> + * Foundation, either version 2 of that License or (at your option) any
> + * later version.
> + *
> + * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
> + * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
> + * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
> + * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
> + * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
> + * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
> + * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
> + * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> + * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
> + * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> + */
> +
> +dma1: dma@101300 {
> +	#address-cells = <1>;
> +	#size-cells = <1>;
> +	compatible = "fsl,eloplus-dma2";
> +	reg = <0x101300 0x4 0x101600 0x4>;
> +	ranges = <0x0 0x101100 0x500>;
> +	cell-index = <1>;
> +	dma-channel@0 {
> +		compatible = "fsl,eloplus-dma-channel";
> +		reg = <0x0 0x80>;
> +		cell-index = <0>;
> +		interrupts = <32 2 0 0>;
> +	};
> +	dma-channel@80 {
> +		compatible = "fsl,eloplus-dma-channel";
> +		reg = <0x80 0x80>;
> +		cell-index = <1>;
> +		interrupts = <33 2 0 0>;
> +	};
> +	dma-channel@100 {
> +		compatible = "fsl,eloplus-dma-channel";
> +		reg = <0x100 0x80>;
> +		cell-index = <2>;
> +		interrupts = <34 2 0 0>;
> +	};
> +	dma-channel@180 {
> +		compatible = "fsl,eloplus-dma-channel";
> +		reg = <0x180 0x80>;
> +		cell-index = <3>;
> +		interrupts = <35 2 0 0>;
> +	};
> +	dma-channel@300 {
> +		compatible = "fsl,eloplus-dma-channel";
> +		reg = <0x300 0x80>;
> +		cell-index = <4>;
> +		interrupts = <80 2 0 0>;
> +	};
> +	dma-channel@380 {
> +		compatible = "fsl,eloplus-dma-channel";
> +		reg = <0x380 0x80>;
> +		cell-index = <5>;
> +		interrupts = <81 2 0 0>;
> +	};
> +	dma-channel@400 {
> +		compatible = "fsl,eloplus-dma-channel";
> +		reg = <0x400 0x80>;
> +		cell-index = <6>;
> +		interrupts = <82 2 0 0>;
> +	};
> +	dma-channel@480 {
> +		compatible = "fsl,eloplus-dma-channel";
> +		reg = <0x480 0x80>;
> +		cell-index = <7>;
> +		interrupts = <83 2 0 0>;
> +	};
> +};
> diff --git a/arch/powerpc/boot/dts/fsl/t4240si-post.dtsi b/arch/powerpc/boot/dts/fsl/t4240si-post.dtsi
> index bd611a9..7d8bac6 100644
> --- a/arch/powerpc/boot/dts/fsl/t4240si-post.dtsi
> +++ b/arch/powerpc/boot/dts/fsl/t4240si-post.dtsi
> @@ -387,8 +387,8 @@
>   		reg	   = <0xea000 0x4000>;
>   	};
>   
> -/include/ "qoriq-dma-0.dtsi"
> -/include/ "qoriq-dma-1.dtsi"
> +/include/ "qoriq-dma2-0.dtsi"
> +/include/ "qoriq-dma2-1.dtsi"
>   
>   /include/ "qoriq-espi-0.dtsi"
>   	spi@110000 {



