Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab3LSPuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:50:21 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:6753 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3LSPuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:50:18 -0500
Message-ID: <52B315B4.6000906@atmel.com>
Date: Thu, 19 Dec 2013 16:50:12 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Wolfram Sang <wsa@the-dreams.de>, Wolfram Sang <wsa@the-dreams.de>
CC: Rob Landley <rob@landley.net>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH] i2c: at91: document clock properties
References: <1387295644-7382-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1387295644-7382-1-git-send-email-b.brezillon@overkiz.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/12/2013 16:54, Boris BREZILLON :
> Document the clock properties required by the at91 i2c bus driver.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>  Documentation/devicetree/bindings/i2c/i2c-at91.txt |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/i2c/i2c-at91.txt b/Documentation/devicetree/bindings/i2c/i2c-at91.txt
> index b689a0d..4fade84 100644
> --- a/Documentation/devicetree/bindings/i2c/i2c-at91.txt
> +++ b/Documentation/devicetree/bindings/i2c/i2c-at91.txt
> @@ -9,6 +9,7 @@ Required properties :
>  - interrupts: interrupt number to the cpu.
>  - #address-cells = <1>;
>  - #size-cells = <0>;
> +- clocks: phandles to input clocks.
>  
>  Optional properties:
>  - Child nodes conforming to i2c bus binding
> @@ -21,6 +22,7 @@ i2c0: i2c@fff84000 {
>  	interrupts = <12 4 6>;
>  	#address-cells = <1>;
>  	#size-cells = <0>;
> +	clocks = <&twi0_clk>;
>  
>  	24c512@50 {
>  		compatible = "24c512";
> 


-- 
Nicolas Ferre
