Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab3LSIpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 03:45:45 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:48322 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab3LSIpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 03:45:43 -0500
Message-ID: <52B2B232.4070608@atmel.com>
Date: Thu, 19 Dec 2013 09:45:38 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Landley <rob@landley.net>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
CC: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: atmel-mci: document clock properties
References: <1387272977-4523-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1387272977-4523-1-git-send-email-b.brezillon@overkiz.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/12/2013 10:36, Boris BREZILLON :
> Document the clock properties required by the atmel-mci driver.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

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
> 


-- 
Nicolas Ferre
