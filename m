Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab3LSIEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 03:04:22 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:30148 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab3LSIEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 03:04:20 -0500
Date: Thu, 19 Dec 2013 09:04:18 +0100
From: Ludovic Desroches <ludovic.desroches@atmel.com>
To: Boris BREZILLON <b.brezillon@overkiz.com>
CC: Arnd Bergmann <arnd@arndb.de>, Rob Landley <rob@landley.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: atmel-mci: document clock properties
Message-ID: <20131219080418.GB3842@ldesroches-Latitude-E6320>
References: <1387272977-4523-1-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1387272977-4523-1-git-send-email-b.brezillon@overkiz.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 10:36:17AM +0100, Boris BREZILLON wrote:
> Document the clock properties required by the atmel-mci driver.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>

> ---
>  .../devicetree/bindings/mmc/atmel-hsmci.txt        |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/mmc/atmel-hsmci.txt b/Documentation/devicetree/bindings/mmc/atmel-hsmci.txt
> index 0a85c70..07ad020 100644
> --- a/Documentation/devicetree/bindings/mmc/atmel-hsmci.txt
> +++ b/Documentation/devicetree/bindings/mmc/atmel-hsmci.txt
> @@ -13,6 +13,9 @@ Required properties:
>  - #address-cells: should be one. The cell is the slot id.
>  - #size-cells: should be zero.
>  - at least one slot node
> +- clock-names: tuple listing input clock names.
> +	Required elements: "mci_clk"
> +- clocks: phandles to input clocks.
>  
>  The node contains child nodes for each slot that the platform uses
>  
> @@ -24,6 +27,8 @@ mmc0: mmc@f0008000 {
>  	interrupts = <12 4>;
>  	#address-cells = <1>;
>  	#size-cells = <0>;
> +	clock-names = "mci_clk";
> +	clocks = <&mci0_clk>;
>  
>  	[ child node definitions...]
>  };
> -- 
> 1.7.9.5
> 
