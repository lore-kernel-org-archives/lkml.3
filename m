Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab3LSPxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:53:12 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:33278 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab3LSPxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:53:08 -0500
Message-ID: <52B3165F.8090206@atmel.com>
Date: Thu, 19 Dec 2013 16:53:03 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>, Rob Landley <rob@landley.net>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Mark Brown <broonie@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] spi/atmel: document clock properties
References: <1387278095-5118-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1387278095-5118-1-git-send-email-b.brezillon@overkiz.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/12/2013 12:01, Boris BREZILLON :
> Document the clock properties required by the spi-atmel driver.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>  .../devicetree/bindings/spi/spi_atmel.txt          |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/spi/spi_atmel.txt b/Documentation/devicetree/bindings/spi/spi_atmel.txt
> index 07e04cd..4f8184d 100644
> --- a/Documentation/devicetree/bindings/spi/spi_atmel.txt
> +++ b/Documentation/devicetree/bindings/spi/spi_atmel.txt
> @@ -5,6 +5,9 @@ Required properties:
>  - reg: Address and length of the register set for the device
>  - interrupts: Should contain spi interrupt
>  - cs-gpios: chipselects
> +- clock-names: tuple listing input clock names.
> +	Required elements: "spi_clk"
> +- clocks: phandles to input clocks.
>  
>  Example:
>  
> @@ -14,6 +17,8 @@ spi1: spi@fffcc000 {
>  	interrupts = <13 4 5>;
>  	#address-cells = <1>;
>  	#size-cells = <0>;
> +	clocks = <&spi1_clk>;
> +	clock-names = "spi_clk";
>  	cs-gpios = <&pioB 3 0>;
>  	status = "okay";
>  
> 


-- 
Nicolas Ferre
