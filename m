Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbbAPKWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:22:05 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:35607 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbbAPKWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:22:01 -0500
Date: Fri, 16 Jan 2015 10:21:35 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "jslaby@suse.cz" <jslaby@suse.cz>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "florian.vaussard@epfl.ch" <florian.vaussard@epfl.ch>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "rrichter@cavium.com" <rrichter@cavium.com>,
        "hytszk@gmail.com" <hytszk@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "antonynpavlov@gmail.com" <antonynpavlov@gmail.com>,
        "Joel.Schopp@amd.com" <Joel.Schopp@amd.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "lea.yan@linaro.org" <lea.yan@linaro.org>,
        "jorge.ramirez-ortiz@linaro.org" <jorge.ramirez-ortiz@linaro.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "orsonzhai@gmail.com" <orsonzhai@gmail.com>,
        "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>,
        "zhizhou.zhang@spreadtrum.com" <zhizhou.zhang@spreadtrum.com>,
        "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>,
        "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>,
        "wei.qiao@spreadtrum.com" <wei.qiao@spreadtrum.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Subject: Re: [PATCH v5 2/5] Documentation: DT: Add bindings for Spreadtrum
 SoC Platform
Message-ID: <20150116102135.GC21809@leverpostej>
References: <sc9836-v5>
 <1421402411-3479-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1421402411-3479-3-git-send-email-chunyan.zhang@spreadtrum.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421402411-3479-3-git-send-email-chunyan.zhang@spreadtrum.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 10:00:08AM +0000, Chunyan Zhang wrote:
> Adds Spreadtrum's prefix "sprd" to vendor-prefixes file.
> Adds the devicetree binding documentations for Spreadtrum's sc9836-uart
> and SC9836 SoC based on the Sharkl64 Platform which is a 64-bit SoC
> Platform of Spreadtrum.
> 
> Signed-off-by: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
> Signed-off-by: Orson Zhai <orson.zhai@spreadtrum.com>
> ---
>  Documentation/devicetree/bindings/arm/sprd.txt     |   11 +++++++++++
>  .../devicetree/bindings/serial/sprd-uart.txt       |    7 +++++++
>  .../devicetree/bindings/vendor-prefixes.txt        |    1 +
>  3 files changed, 19 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/sprd.txt
>  create mode 100644 Documentation/devicetree/bindings/serial/sprd-uart.txt
> 
> diff --git a/Documentation/devicetree/bindings/arm/sprd.txt b/Documentation/devicetree/bindings/arm/sprd.txt
> new file mode 100644
> index 0000000..31a629d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/sprd.txt
> @@ -0,0 +1,11 @@
> +Spreadtrum SoC Platforms Device Tree Bindings
> +----------------------------------------------------
> +
> +Sharkl64 is a Spreadtrum's SoC Platform which is based
> +on ARM 64-bit processor.
> +
> +SC9836 openphone board with SC9836 SoC based on the
> +Sharkl64 Platform shall have the following properties.
> +
> +Required root node properties:
> +        - compatible = "sprd,sc9836-openphone", "sprd,sc9836";
> diff --git a/Documentation/devicetree/bindings/serial/sprd-uart.txt b/Documentation/devicetree/bindings/serial/sprd-uart.txt
> new file mode 100644
> index 0000000..2aff0f2
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/serial/sprd-uart.txt
> @@ -0,0 +1,7 @@
> +* Spreadtrum serial UART
> +
> +Required properties:
> +- compatible: must be "sprd,sc9836-uart"
> +- reg: offset and length of the register set for the device
> +- interrupts: exactly one interrupt specifier
> +- clocks: phandles to input clocks.

The order and relevance of each should be specified. If you have
multiple clocks I would strongly recommend you use clock-names to
distinguish them.

Otherwise this looks fine.

Mark.

> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index b1df0ad..0a8384f 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -153,6 +153,7 @@ snps	Synopsys, Inc.
>  solidrun	SolidRun
>  sony	Sony Corporation
>  spansion	Spansion Inc.
> +sprd	Spreadtrum Communications Inc.
>  st	STMicroelectronics
>  ste	ST-Ericsson
>  stericsson	ST-Ericsson
> -- 
> 1.7.9.5
> 
> 
