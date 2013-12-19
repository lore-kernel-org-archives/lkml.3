Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab3LSICt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 03:02:49 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:29924 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab3LSICq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 03:02:46 -0500
Date: Thu, 19 Dec 2013 09:02:42 +0100
From: Ludovic Desroches <ludovic.desroches@atmel.com>
To: Boris BREZILLON <b.brezillon@overkiz.com>
CC: Rob Landley <rob@landley.net>, Wolfram Sang <wsa@the-dreams.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH] i2c: at91: document clock properties
Message-ID: <20131219080242.GA3842@ldesroches-Latitude-E6320>
Mail-Followup-To: Boris BREZILLON <b.brezillon@overkiz.com>,
	Rob Landley <rob@landley.net>, Wolfram Sang <wsa@the-dreams.de>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-i2c@vger.kernel.org
References: <1387295644-7382-1-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1387295644-7382-1-git-send-email-b.brezillon@overkiz.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 04:54:04PM +0100, Boris BREZILLON wrote:
> Document the clock properties required by the at91 i2c bus driver.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>

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
> -- 
> 1.7.9.5
> 
