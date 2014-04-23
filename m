Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbaDWMCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 08:02:41 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:55296 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbaDWMCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:02:38 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 4/4] of/irq: Typo s/interrupts-names/interrupt-names/g
To: Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>
In-Reply-To: <1398192025-31523-4-git-send-email-geert+renesas@glider.be>
References: <1398192025-31523-1-git-send-email-geert+renesas@glider.be>
	<1398192025-31523-4-git-send-email-geert+renesas@glider.be>
Date: Wed, 23 Apr 2014 13:02:25 +0100
Message-Id: <20140423120226.0E1FDC40969@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014 20:40:25 +0200, Geert Uytterhoeven <geert+renesas@glider.be> wrote:
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Thanks Geert,

Applied all, but squashed into a single patch. I'll send it up to Linus
as a fix for 3.15

g.

> ---
>  drivers/of/irq.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
> index 9bcf2cf19357..e2e4c548a42f 100644
> --- a/drivers/of/irq.c
> +++ b/drivers/of/irq.c
> @@ -364,7 +364,7 @@ int of_irq_to_resource(struct device_node *dev, int index, struct resource *r)
>  
>  		memset(r, 0, sizeof(*r));
>  		/*
> -		 * Get optional "interrupts-names" property to add a name
> +		 * Get optional "interrupt-names" property to add a name
>  		 * to the resource.
>  		 */
>  		of_property_read_string_index(dev, "interrupt-names", index,
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

