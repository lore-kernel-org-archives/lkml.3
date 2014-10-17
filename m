Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbaJQMup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 08:50:45 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47164 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751251AbaJQMuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 08:50:44 -0400
Date: Fri, 17 Oct 2014 13:50:34 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "artagnon@gmail.com" <artagnon@gmail.com>,
        "rrichter@cavium.com" <rrichter@cavium.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "zhizhou.zhang@spreadtrum.com" <zhizhou.zhang@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "sprdlinux@freelists.org" <sprdlinux@freelists.org>
Subject: Re: [PATCH v2 2/5] Documentation: DT: Add bindings for Spreadtrum
 Sharkl Platform
Message-ID: <20141017125033.GA5587@leverpostej>
References: <sprd-1017-v2>
 <1413539665-11484-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1413539665-11484-3-git-send-email-chunyan.zhang@spreadtrum.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413539665-11484-3-git-send-email-chunyan.zhang@spreadtrum.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 10:54:22AM +0100, Chunyan Zhang wrote:
> Adds Spreadtrum's prefix "sprd" to vendor-prefixes file.
> Adds the devicetree binding documentation for Spreadtrum's serial
> and Sharkl3 SoC based on the Sharkl Platform which is the 64-bit
> SoC Platform of Spreadtrum.
> 
> Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
> ---
>  Documentation/devicetree/bindings/arm/sprd.txt     |   11 +++++++++++
>  .../devicetree/bindings/serial/sprd-serial.txt     |    6 ++++++
>  .../devicetree/bindings/vendor-prefixes.txt        |    1 +
>  3 files changed, 18 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/sprd.txt
>  create mode 100644 Documentation/devicetree/bindings/serial/sprd-serial.txt
> 
> diff --git a/Documentation/devicetree/bindings/arm/sprd.txt b/Documentation/devicetree/bindings/arm/sprd.txt
> new file mode 100644
> index 0000000..40b40d6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/sprd.txt
> @@ -0,0 +1,11 @@
> +Spreadtrum Sharkl Platforms Device Tree Bindings
> +----------------------------------------------------
> +
> +Sharkl is a Spreadtrum's SoC Platform which is based
> +on ARM 64-bit processor.
> +
> +Sharkl3 FPGA board with Sharkl3 SoC based on the
> +Sharkl Platform shall have the following properties.
> +
> +Required root node properties:
> +        - compatible = "sprd,sharkl3-fpga", "sprd,sharkl3";
> diff --git a/Documentation/devicetree/bindings/serial/sprd-serial.txt b/Documentation/devicetree/bindings/serial/sprd-serial.txt
> new file mode 100644
> index 0000000..c97b0a6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/serial/sprd-serial.txt
> @@ -0,0 +1,6 @@
> +* Spreadtrum serial UART
> +
> +Required properties:
> +- compatible: must be "sprd,serial"
> +- reg: offset and length of the register set for the device
> +- interrupts: exactly one interrupt specifier

I'm still a little wary of then name "sprd,serial". What was the first
device to feature this UART, if it doesn't have a specific name of its
own?

> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index ac7269f..5dbf7db 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -129,6 +129,7 @@ smsc	Standard Microsystems Corporation
>  snps 	Synopsys, Inc.
>  solidrun	SolidRun
>  spansion	Spansion Inc.
> +sprd	Spreadtrum Communications Inc.
>  st	STMicroelectronics
>  ste	ST-Ericsson
>  stericsson	ST-Ericsson

The vendor prefix addition looks fine to me.

Thanks,
Mark.
