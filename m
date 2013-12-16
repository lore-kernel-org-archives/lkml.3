Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab3LPJqk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:46:40 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:48728 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515Ab3LPJqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 04:46:38 -0500
Message-ID: <52AECBFC.5000207@atmel.com>
Date: Mon, 16 Dec 2013 10:46:36 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>, Rob Landley <rob@landley.net>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] devicetree: macb: Document clock properties
References: <1386972205-32733-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1386972205-32733-1-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/12/2013 23:03, Soren Brinkmann :
> The macb driver uses the clock bindings. Document the required
> properties, especially the driver specific clock-names.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks.

> ---
>  Documentation/devicetree/bindings/net/macb.txt | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
> index 4ff65047bb9a..70af2ec12b09 100644
> --- a/Documentation/devicetree/bindings/net/macb.txt
> +++ b/Documentation/devicetree/bindings/net/macb.txt
> @@ -10,6 +10,10 @@ Required properties:
>  - interrupts: Should contain macb interrupt
>  - phy-mode: String, operation mode of the PHY interface.
>    Supported values are: "mii", "rmii", "gmii", "rgmii".
> +- clock-names: Tuple listing input clock names.
> +	Required elements: 'pclk', 'hclk'
> +	Optional elements: 'tx_clk'
> +- clocks: Phandles to input clocks.
>  
>  Optional properties:
>  - local-mac-address: 6 bytes, mac address
> @@ -22,4 +26,6 @@ Examples:
>  		interrupts = <21>;
>  		phy-mode = "rmii";
>  		local-mac-address = [3a 0e 03 04 05 06];
> +		clock-names = "pclk", "hclk", "tx_clk";
> +		clocks = <&clkc 30>, <&clkc 30>, <&clkc 13>;
>  	};
> 


-- 
Nicolas Ferre
