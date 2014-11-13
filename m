Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403AbaKMJsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 04:48:11 -0500
Received: from down.free-electrons.com ([37.187.137.238]:37692 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932215AbaKMJsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 04:48:07 -0500
Date: Thu, 13 Nov 2014 10:48:03 +0100
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: at91: Add Special Function Registers binding
 documentation
Message-ID: <20141113104803.179a7529@bbrezillon>
In-Reply-To: <1415632471-14672-1-git-send-email-alexandre.belloni@free-electrons.com>
References: <1415632471-14672-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2014 16:14:29 +0100
Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:

> The special function registers gather some registers that allow to tweak
> features provided by IPs controlled through another register range.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Once you've fixed your dtsi you can add my

Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

on the whole series.

> ---
>  Documentation/devicetree/bindings/arm/atmel-at91.txt | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/atmel-at91.txt b/Documentation/devicetree/bindings/arm/atmel-at91.txt
> index 562cda9d86d9..a6427de45785 100644
> --- a/Documentation/devicetree/bindings/arm/atmel-at91.txt
> +++ b/Documentation/devicetree/bindings/arm/atmel-at91.txt
> @@ -136,3 +136,20 @@ Example:
>  		compatible = "atmel,at91sam9260-rstc";
>  		reg = <0xfffffd00 0x10>;
>  	};
> +
> +Special Function Registers (SFR)
> +
> +Special Function Registers (SFR) manage specific aspects of the integrated
> +memory, bridge implementations, processor and other functionality not controlled
> +elsewhere.
> +
> +required properties:
> +- compatible: Should be "atmel,<chip>-sfr", "syscon".
> +  <chip> can be "at91sam9260", "at91sam9rl" or "at91sam9x5".
> +- reg: Should contain registers location and length
> +
> +	sfr@f0038000 {
> +		compatible = "atmel,sama5d3-sfr", "syscon";
> +		reg = <0xf0038000 0x4000>;
> +	};
> +



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
