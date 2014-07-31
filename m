Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257AbaGaO1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 10:27:00 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:35790 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaGaO06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 10:26:58 -0400
Message-ID: <53DA5230.1050200@cogentembedded.com>
Date: Thu, 31 Jul 2014 18:26:56 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, nsekhar@ti.com, robh+dt@kernel.org
CC: devicetree@vger.kernel.org, davinci-linux-open-source@linux.davincidsp.com,
        linux@arm.linux.org.uk, pawel.moll@arm.com,
        khilman@deeprootsystems.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/6] ARM: DTS: da850: Add node for edma0
References: <1406801934-23334-1-git-send-email-peter.ujfalusi@ti.com> <1406801934-23334-3-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1406801934-23334-3-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2014 02:18 PM, Peter Ujfalusi wrote:

> Add DT node for edma0.

> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>   arch/arm/boot/dts/da850.dtsi | 6 ++++++
>   1 file changed, 6 insertions(+)

> diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
> index b695548dbb4e..41ce4e8bf227 100644
> --- a/arch/arm/boot/dts/da850.dtsi
> +++ b/arch/arm/boot/dts/da850.dtsi
> @@ -150,6 +150,12 @@
>   			};
>
>   		};
> +		edma0: edma@01c00000 {
> +			compatible = "ti,edma3";
> +			reg =	<0x0 0x10000>;

    Why the mismatch between the unit-address part of the node name and the 
"reg" property?

> +			interrupts = <11 13 12>;
> +			#dma-cells = <1>;
> +		};

WBR, Sergei

