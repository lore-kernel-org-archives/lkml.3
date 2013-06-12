Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756619Ab3FLPvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 11:51:43 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40908 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab3FLPvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 11:51:42 -0400
Message-ID: <51B8990A.8030506@wwwdotorg.org>
Date: Wed, 12 Jun 2013 09:51:38 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: J Keerthy <j-keerthy@ti.com>
CC: b-cousson@ti.com, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldewangan@nvidia.com, grant.likely@secretlab.ca, swarren@nvidia.com,
        sameo@linux.intel.com, gg@slimlogic.co.uk, lee.jones@linaro.org
Subject: Re: [PATCH v4] ARM: dts: OMAP5: Add palmas MFD node and regulator
 nodes
References: <1371025140-25376-1-git-send-email-j-keerthy@ti.com>
In-Reply-To: <1371025140-25376-1-git-send-email-j-keerthy@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 02:19 AM, J Keerthy wrote:
> This patch adds Palmas MFD node and the regulator nodes for OMAP5.
> 
> The node definitions are based on: https://lkml.org/lkml/2013/6/6/25
> 
> Boot tested on omap5-uevm board.

Reviewed-by: Stephen Warren <swarren@nvidia.com>

> diff --git a/arch/arm/boot/dts/omap5-uevm.dts b/arch/arm/boot/dts/omap5-uevm.dts

> +	palmas: palmas@48 {
> +		reg = <0x48>;
> +		interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>; /* IRQ_SYS_1N */
> +		interrupt-parent = <&gic>;
> +		compatible = "ti,palmas";

... although personally I prefer the compatible property to be right at
the top of each node, since it's what implies the schema for the rest of
the node. That's a tiny nit though; feel free to ignore it if the OMAP
files don't follow that convention.
