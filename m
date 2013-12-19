Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab3LSPxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:53:55 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:7366 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab3LSPxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:53:53 -0500
Message-ID: <52B3168B.10004@atmel.com>
Date: Thu, 19 Dec 2013 16:53:47 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>, Rob Landley <rob@landley.net>,
        Mark Brown <broonie@linaro.org>
CC: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] drivers/misc: atmel-ssc: document clock properties
References: <1387292507-6606-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1387292507-6606-1-git-send-email-b.brezillon@overkiz.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/12/2013 16:01, Boris BREZILLON :
> Document the clock properties required by the atmel-ssc driver.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>  .../devicetree/bindings/misc/atmel-ssc.txt         |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/misc/atmel-ssc.txt b/Documentation/devicetree/bindings/misc/atmel-ssc.txt
> index a45ae08..60960b2 100644
> --- a/Documentation/devicetree/bindings/misc/atmel-ssc.txt
> +++ b/Documentation/devicetree/bindings/misc/atmel-ssc.txt
> @@ -6,6 +6,9 @@ Required properties:
>  	- atmel,at91sam9g45-ssc: support dma transfer
>  - reg: Should contain SSC registers location and length
>  - interrupts: Should contain SSC interrupt
> +- clock-names: tuple listing input clock names.
> +	Required elements: "pclk"
> +- clocks: phandles to input clocks.
>  
>  
>  Required properties for devices compatible with "atmel,at91sam9g45-ssc":
> @@ -20,6 +23,8 @@ ssc0: ssc@fffbc000 {
>  	compatible = "atmel,at91rm9200-ssc";
>  	reg = <0xfffbc000 0x4000>;
>  	interrupts = <14 4 5>;
> +	clocks = <&ssc0_clk>;
> +	clock-names = "pclk";
>  };
>  
>  - DMA transfer:
> 


-- 
Nicolas Ferre
