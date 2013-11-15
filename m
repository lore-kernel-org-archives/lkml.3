Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab3KONjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 08:39:12 -0500
Received: from 1.mo2.mail-out.ovh.net ([46.105.63.121]:46059 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751046Ab3KONjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 08:39:03 -0500
Date: Fri, 15 Nov 2013 14:41:14 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: at91/dt: binding: add missing compatibility string
 in SDRAM/DDR documentation
Message-ID: <20131115134114.GL28304@ns203013.ovh.net>
References: <1384510235-16083-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384510235-16083-1-git-send-email-nicolas.ferre@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Ovh-Tracer-Id: 2591258636726152044
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

On 11:10 Fri 15 Nov     , Nicolas Ferre wrote:
> The "atmel,at91rm9200-sdramc" was missing from binding documentation.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

Best Regards,
J.
> ---
>  Documentation/devicetree/bindings/arm/atmel-at91.txt | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/atmel-at91.txt b/Documentation/devicetree/bindings/arm/atmel-at91.txt
> index 1196290..d2170e7 100644
> --- a/Documentation/devicetree/bindings/arm/atmel-at91.txt
> +++ b/Documentation/devicetree/bindings/arm/atmel-at91.txt
> @@ -50,7 +50,8 @@ Example:
>  	};
>  
>  RAMC SDRAM/DDR Controller required properties:
> -- compatible: Should be "atmel,at91sam9260-sdramc",
> +- compatible: Should be "atmel,at91rm9200-sdramc",
> +			"atmel,at91sam9260-sdramc",
>  			"atmel,at91sam9g45-ddramc",
>  - reg: Should contain registers location and length
>    For at91sam9263 and at91sam9g45 you must specify 2 entries.
> -- 
> 1.8.2.2
> 
