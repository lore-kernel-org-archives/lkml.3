Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab3KZHEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 02:04:36 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:50761 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146Ab3KZHEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 02:04:32 -0500
Message-ID: <529447A7.1050605@ti.com>
Date: Tue, 26 Nov 2013 12:33:03 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: "Khoronzhuk, Ivan" <ivan.khoronzhuk@ti.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>
CC: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 06/12] mtd: nand: davinci: adjust DT properties to MTD
 generic
References: <1384187188-5776-1-git-send-email-ivan.khoronzhuk@ti.com>, <1384187188-5776-7-git-send-email-ivan.khoronzhuk@ti.com> <4F5844B3A985794BA902E12C070812375F8D20@DNCE04.ent.ti.com>
In-Reply-To: <4F5844B3A985794BA902E12C070812375F8D20@DNCE04.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 November 2013 10:31 PM, Khoronzhuk, Ivan wrote:
> The properties davinci-ecc-mode, davinci-nand-use-bbt, davinci-nand-buswidth
> are MTD generic. Correct names for them are: nand-ecc-mode, nand-on-flash-bbt,
> nand-bus-width accordingly. So rename them in dts and documentation.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
>  .../devicetree/bindings/mtd/davinci-nand.txt       |   25 ++++++++++++++++----
>  drivers/mtd/nand/davinci_nand.c                    |   11 ++++++---
>  2 files changed, 28 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mtd/davinci-nand.txt b/Documentation/devicetree/bindings/mtd/davinci-nand.txt
> index d2a3fc0..befaa5b 100644
> --- a/Documentation/devicetree/bindings/mtd/davinci-nand.txt
> +++ b/Documentation/devicetree/bindings/mtd/davinci-nand.txt
> @@ -37,7 +37,7 @@ Recommended properties :
>  - ti,davinci-mask-chipsel:     mask for chipselect address. Needed to mask
>                                 addresses for given chipselect.
> 
> -- ti,davinci-ecc-mode:         operation mode of the NAND ecc mode. ECC mode
> +- nand-ecc-mode:               operation mode of the NAND ecc mode. ECC mode
>                                 valid values for davinci driver:
>                                 - "none"
>                                 - "soft"
> @@ -45,10 +45,25 @@ Recommended properties :
> 
>  - ti,davinci-ecc-bits:         used ECC bits, currently supported 1 or 4.
> 
> -- ti,davinci-nand-buswidth:    buswidth 8 or 16.

Shouldn't we keep the documentation for existing bindings while just
marking them as deprecated?

Thanks,
Sekhar

