Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab3KOOE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 09:04:29 -0500
Received: from 4.mo2.mail-out.ovh.net ([87.98.172.75]:52946 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751767Ab3KOOER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 09:04:17 -0500
Date: Fri, 15 Nov 2013 14:41:30 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: at91/dt: binding: add precision to AIC documentation
Message-ID: <20131115134130.GM28304@ns203013.ovh.net>
References: <1384510173-15901-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384510173-15901-1-git-send-email-nicolas.ferre@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 2595762236399790956
X-Ovh-Remote: 91.121.171.124 (ns203013.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrieehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrieehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:09 Fri 15 Nov     , Nicolas Ferre wrote:
> In response to the "undocumented compatible strings" message, here is a
> patch which is adding the precision of two "chips" that should be used for
> the "atmel,<chip>-aic" compatibility string.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.
> ---
>  Documentation/devicetree/bindings/arm/atmel-aic.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/atmel-aic.txt b/Documentation/devicetree/bindings/arm/atmel-aic.txt
> index ad031211..2742e9c 100644
> --- a/Documentation/devicetree/bindings/arm/atmel-aic.txt
> +++ b/Documentation/devicetree/bindings/arm/atmel-aic.txt
> @@ -2,6 +2,7 @@
>  
>  Required properties:
>  - compatible: Should be "atmel,<chip>-aic"
> +  <chip> can be "at91rm9200" or "sama5d3"
>  - interrupt-controller: Identifies the node as an interrupt controller.
>  - interrupt-parent: For single AIC system, it is an empty property.
>  - #interrupt-cells: The number of cells to define the interrupts. It should be 3.
> -- 
> 1.8.2.2
> 
