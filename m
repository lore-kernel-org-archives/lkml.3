Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab3JUTBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 15:01:21 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:55918 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab3JUTBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 15:01:19 -0400
Message-ID: <526579FB.10005@cogentembedded.com>
Date: Mon, 21 Oct 2013 23:01:15 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>
CC: devicetree@vger.kernel.org, linux-omap@vger.kernel.org,
        Jyri Sarha <jsarha@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: dts: am4372: Add McASP nodes
References: <1382348758-1083-1-git-send-email-peter.ujfalusi@ti.com>
In-Reply-To: <1382348758-1083-1-git-send-email-peter.ujfalusi@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10/21/2013 01:45 PM, Peter Ujfalusi wrote:

> Add nodes for McASP0 and McASP1 for AM43xx.

> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
>   arch/arm/boot/dts/am4372.dtsi | 27 +++++++++++++++++++++++++++
>   1 file changed, 27 insertions(+)

> diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
> index c328d5c..defaad1 100644
> --- a/arch/arm/boot/dts/am4372.dtsi
> +++ b/arch/arm/boot/dts/am4372.dtsi
> @@ -633,5 +633,32 @@
>   			dma-names = "tx", "rx";
>   		};
>
> +		mcasp0: mcasp@48038000 {

    According to ePAPR spec [1], "the name of a node should be somewhat 
generic, reflecting the function of the device and not its
precise programming model". In this case probably "sound"?

[1] http://www.power.org/resources/downloads/Power_ePAPR_APPROVED_v1.0.pdf

WBR, Sergei

