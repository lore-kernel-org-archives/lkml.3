Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055AbaGKOYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:24:36 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:35738 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624AbaGKOST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:18:19 -0400
Date: Fri, 11 Jul 2014 11:06:30 +0200
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Magnus Damm <magnus.damm@gmail.com>, devicetree@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 02/13] irqchip: renesas-intc-irqpin: Document
 SoC-specific bindings
Message-ID: <20140711090630.GI12420@verge.net.au>
References: <1404908623-909-1-git-send-email-geert+renesas@glider.be>
 <1404908623-909-3-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404908623-909-3-git-send-email-geert+renesas@glider.be>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 02:23:32PM +0200, Geert Uytterhoeven wrote:
> The documentation only mentioned the generic fallback compatible property.
> Add the missing SoC-specific compatible properties, which are already in
> use.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Simon Horman <horms+renesas@verge.net.au>

> ---
>  .../bindings/interrupt-controller/renesas,intc-irqpin.txt         | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/interrupt-controller/renesas,intc-irqpin.txt b/Documentation/devicetree/bindings/interrupt-controller/renesas,intc-irqpin.txt
> index 1f8b0c507c26..c73acd060093 100644
> --- a/Documentation/devicetree/bindings/interrupt-controller/renesas,intc-irqpin.txt
> +++ b/Documentation/devicetree/bindings/interrupt-controller/renesas,intc-irqpin.txt
> @@ -2,7 +2,13 @@ DT bindings for the R-/SH-Mobile irqpin controller
>  
>  Required properties:
>  
> -- compatible: has to be "renesas,intc-irqpin"
> +- compatible: has to be "renesas,intc-irqpin-<soctype>", "renesas,intc-irqpin"
> +  as fallback.
> +  Examples with soctypes are:
> +    - "renesas,intc-irqpin-r8a7740" (R-Mobile A1)
> +    - "renesas,intc-irqpin-r8a7778" (R-Car M1A)
> +    - "renesas,intc-irqpin-r8a7779" (R-Car H1)
> +    - "renesas,intc-irqpin-sh73a0" (SH-Mobile AG5)
>  - #interrupt-cells: has to be <2>: an interrupt index and flags, as defined in
>    interrupts.txt in this directory
>  
> -- 
> 1.9.1
> 
