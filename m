Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbaFXGoP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 02:44:15 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:39333 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbaFXGoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 02:44:13 -0400
MIME-Version: 1.0
In-Reply-To: <b0dfcba4-7319-4687-a455-bfcddf61b7d1@BN1AFFO11FD028.protection.gbl>
References: <b0dfcba4-7319-4687-a455-bfcddf61b7d1@BN1AFFO11FD028.protection.gbl>
Date: Tue, 24 Jun 2014 12:14:10 +0530
Message-ID: <CALHRZup3_eFiw8iSJJmxy0dHDeHLnb2fAfRtKPTW1UQ2U+cEig@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] usb: doc: udc-xilinx: Add devicetree bindings
From: sundeep subbaraya <sundeep.lkml@gmail.com>
To: Subbaraya Sundeep Bhatta <subbaraya.sundeep.bhatta@xilinx.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michals@xilinx.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping

Thanks,
Sundeep.B.S.

On Tue, Jun 10, 2014 at 5:34 PM,  <subbaraya.sundeep.bhatta@xilinx.com> wrote:
> From: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
>
> Add devicetree bindings for Xilinx axi udc driver.
>
> Signed-off-by: Subbaraya Sundeep Bhatta <sbhatta@xilinx.com>
> ---
> Changes for v3:
>         - None
> Changes for v2:
>         - replaced xlnx,include-dma with xlnx,has-builtin-dma
>
>  .../devicetree/bindings/usb/udc-xilinx.txt         |   20 ++++++++++++++++++++
>  1 files changed, 20 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/usb/udc-xilinx.txt
>
> diff --git a/Documentation/devicetree/bindings/usb/udc-xilinx.txt b/Documentation/devicetree/bindings/usb/udc-xilinx.txt
> new file mode 100644
> index 0000000..7c24fac
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/usb/udc-xilinx.txt
> @@ -0,0 +1,20 @@
> +Xilinx AXI USB2 device controller
> +
> +Required properties:
> +- compatible           : Should be "xlnx,axi-usb2-device-4.00.a"
> +- reg                  : Physical base address and size of the Axi USB2
> +                         device registers map.
> +- interrupts           : Property with a value describing the interrupt
> +                         number.
> +- interrupt-parent     : Must be core interrupt controller
> +- xlnx,include-dma     : if DMA is included
> +
> +Example:
> +               axi-usb2-device@42e00000 {
> +                        compatible = "xlnx,axi-usb2-device-4.00.a";
> +                        interrupt-parent = <0x1>;
> +                        interrupts = <0x0 0x39 0x1>;
> +                        reg = <0x42e00000 0x10000>;
> +                        xlnx,has-builtin-dma;
> +                };
> +
> --
> 1.7.4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
