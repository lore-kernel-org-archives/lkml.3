Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347AbaEXRvm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 13:51:42 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:45190 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbaEXRvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 13:51:40 -0400
X-Auth-Info: xr6pmiN/vBLpyH5cgAja1NcU3MHS8rAookWjaxq9Nug=
From: Marek Vasut <marex@denx.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] dt: Add DT bindings documentation for SUNXI Security System
Date: Sat, 24 May 2014 13:21:32 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.12.4; x86_64; ; )
Cc: LABBE Corentin <clabbe.montjoie@gmail.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, maxime.ripard@free-electrons.com,
        linux@arm.linux.org.uk, herbert@gondor.apana.org.au,
        davem@davemloft.net, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
References: <1400771396-9686-1-git-send-email-clabbe.montjoie@gmail.com> <1400771396-9686-2-git-send-email-clabbe.montjoie@gmail.com>
In-Reply-To: <1400771396-9686-2-git-send-email-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201405241321.32147.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 22, 2014 at 05:09:54 PM, LABBE Corentin wrote:

Missing commit message. Please fix this and send a V2.

> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> ---
>  Documentation/devicetree/bindings/crypto/sunxi-ss.txt | 9 +++++++++
>  1 file changed, 9 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/sunxi-ss.txt
> 
> diff --git a/Documentation/devicetree/bindings/crypto/sunxi-ss.txt
> b/Documentation/devicetree/bindings/crypto/sunxi-ss.txt new file mode
> 100644
> index 0000000..356563b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/sunxi-ss.txt
> @@ -0,0 +1,9 @@
> +* Allwinner Security System found on A20 SoC
> +
> +Required properties:
> +- compatible : Should be "allwinner,sun7i-a20-crypto".

Why sun7i-a20 ? Is the crypto unit different in other sunxi chips ? Can that not 
be described by DT props ?

> +- reg: Should contain the SS register location and length.

SS? What is that? Fix this text to be actually descriptive please.

> +- interrupts: Should contain the IRQ line for the SS.
> +- clocks : A phandle to the functional clock node of the SS module
> +- clock-names : Name of the functional clock, should be "ahb" and "mod".
> +

Best regards,
Marek Vasut
