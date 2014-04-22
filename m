Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505AbaDVRWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 13:22:00 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:43515 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932861AbaDVRV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 13:21:58 -0400
Message-ID: <5356A531.7030606@gmail.com>
Date: Tue, 22 Apr 2014 19:21:53 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        tj@kernel.org
CC: alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] Documentation: bindings: add the berlin-achi compatible
 to the ahci platform
References: <1398181105-19714-1-git-send-email-antoine.tenart@free-electrons.com> <1398181105-19714-3-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1398181105-19714-3-git-send-email-antoine.tenart@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 05:38 PM, Antoine Ténart wrote:
> The berlin-achi driver allows Berlin SoCs to support their AHCI SATA controller.
> Add the compatible to the device tree bindings documentation.
> 
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>  Documentation/devicetree/bindings/ata/ahci-platform.txt | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/ata/ahci-platform.txt b/Documentation/devicetree/bindings/ata/ahci-platform.txt
> index 48b285ffa3a6..9987b63aaa10 100644
> --- a/Documentation/devicetree/bindings/ata/ahci-platform.txt
> +++ b/Documentation/devicetree/bindings/ata/ahci-platform.txt
> @@ -7,7 +7,8 @@ Required properties:
>  - compatible        : compatible list, one of "snps,spear-ahci",
>                        "snps,exynos5440-ahci", "ibm,476gtr-ahci",
>                        "allwinner,sun4i-a10-ahci", "fsl,imx53-ahci"
> -                      "fsl,imx6q-ahci" or "snps,dwc-ahci"
> +                      "fsl,imx6q-ahci", "snps,dwc-ahci" or
> +		      "marvell,berlin-ahci"

Besides the typo Thomas already mentioned, it looks like the compatibles
are indented by spaces while you have tabs.

Sebastian

>  - interrupts        : <interrupt mapping for SATA IRQ>
>  - reg               : <registers mapping>
>  
> 

