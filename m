Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbaAWPQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 10:16:59 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:44881 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaAWPQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 10:16:57 -0500
MIME-Version: 1.0
In-Reply-To: <1390458628-30152-1-git-send-email-linux@prisktech.co.nz>
References: <1390458628-30152-1-git-send-email-linux@prisktech.co.nz>
Date: Thu, 23 Jan 2014 09:16:57 -0600
Message-ID: <CAL_JsqJNHJ379QLxSoKEca33ZcFiO2TZxLWck-Ue1vAxozjY7A@mail.gmail.com>
Subject: Re: [PATCH] serial: vt8500: Add missing binding document for
 arch-vt8500 serial driver.
From: Rob Herring <robherring2@gmail.com>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 12:30 AM, Tony Prisk <linux@prisktech.co.nz> wrote:
> The binding document for the vt8500/wm8xxx SoC UART driver is missing.
> This patch adds the binding document.
>
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> ---

Applied. Thanks.

Rob

>  .../devicetree/bindings/serial/vt8500-uart.txt     |   26 ++++++++++++++++++++
>  1 file changed, 26 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/serial/vt8500-uart.txt
>
> diff --git a/Documentation/devicetree/bindings/serial/vt8500-uart.txt b/Documentation/devicetree/bindings/serial/vt8500-uart.txt
> new file mode 100644
> index 0000000..795c393
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/serial/vt8500-uart.txt
> @@ -0,0 +1,26 @@
> +* VIA VT8500 and WonderMedia WM8xxx UART Controller
> +
> +Required properties:
> +- compatible: should be "via,vt8500-uart"
> +
> +- reg: base physical address of the controller and length of memory mapped
> +       region.
> +
> +- interrupts: hardware interrupt number
> +
> +- clocks: shall be the input parent clock phandle for the clock. This should
> +       be the 24Mhz reference clock.
> +
> +Aliases may be defined to ensure the correct ordering of the uarts.
> +
> +Example:
> +       aliases {
> +               serial0 = &uart0;
> +       };
> +
> +       uart0: serial@d8200000 {
> +               compatible = "via,vt8500-uart";
> +               reg = <0xd8200000 0x1040>;
> +               interrupts = <32>;
> +               clocks = <&clkuart0>;
> +       };
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
