Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755406AbaIHWdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 18:33:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35954 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936AbaIHWdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 18:33:15 -0400
Date: Mon, 8 Sep 2014 15:33:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: linux-kernel@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, jslaby@suse.cz,
        grant.likely@linaro.org, alan@linux.intel.com, varkabhadram@gmail.com,
        tklauser@distanz.ch, heiko@sntech.de, yingjoe.chen@gmail.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v4 2/2] DTS: serial: Add bindings documention for the
 Mediatek UARTs
Message-ID: <20140908223314.GA26151@kroah.com>
References: <1407852737-17265-1-git-send-email-matthias.bgg@gmail.com>
 <1407852737-17265-3-git-send-email-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407852737-17265-3-git-send-email-matthias.bgg@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 04:12:17PM +0200, Matthias Brugger wrote:
> This patch adds the devicetree documentation for the Mediatek UART.
> 
> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
> ---
>  .../devicetree/bindings/serial/mtk-uart.txt        |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/serial/mtk-uart.txt
> 
> diff --git a/Documentation/devicetree/bindings/serial/mtk-uart.txt b/Documentation/devicetree/bindings/serial/mtk-uart.txt
> new file mode 100644
> index 0000000..6ca0e15
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/serial/mtk-uart.txt
> @@ -0,0 +1,20 @@
> +* Mediatek Universal Asynchronous Receiver/Transmitter (UART)
> +
> +Required properties:
> +- compatible: "mediatek,mt6577-uart"
> +  Compatibility with mt6577, mt6589, mt6582
> +
> +- reg: The base address of the UART register bank.
> +
> +- interrupts: A single interrupt specifier.
> +
> +- clocks: Clock driving the hardware.
> +
> +Example:
> +
> +	uart0: serial@11006000 {
> +		compatible = "mediatek,mt6577-uart";
> +		reg = <0x11006000 0x400>;
> +		interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_LOW>;
> +		clocks = <&uart_clk>;
> +	};
> -- 
> 1.7.9.5

Resend this one as well with the 1/2 patch please.

thanks,

greg k-h
