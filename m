Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435AbaKQHQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 02:16:35 -0500
Received: from mail-bn1bon0113.outbound.protection.outlook.com ([157.56.111.113]:43088
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751049AbaKQHQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 02:16:33 -0500
Date: Mon, 17 Nov 2014 13:54:45 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
CC: <sebastian.hesselbarth@gmail.com>, <balbi@ti.com>,
        <p.zabel@pengutronix.de>, <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 09/13] Documentation: bindings: add doc for the USB2
 ChipIdea USB driver
Message-ID: <20141117055444.GD30017@shlinux2>
References: <1415978763-27345-1-git-send-email-antoine.tenart@free-electrons.com>
 <1415978763-27345-10-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1415978763-27345-10-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(51704005)(199003)(24454002)(189002)(21056001)(33716001)(46102003)(92726001)(84676001)(50466002)(97756001)(87936001)(83506001)(110136001)(104016003)(92566001)(6806004)(44976005)(31966008)(23726002)(19580395003)(4396001)(68736004)(19580405001)(86362001)(97736003)(105606002)(95666004)(33656002)(102836001)(77156002)(64706001)(46406003)(106466001)(62966003)(47776003)(107046002)(20776003)(120916001)(54356999)(76176999)(50986999)(99396003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0634;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0634;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0634;
X-Forefront-PRVS: 03982FDC1D
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0634;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2014 at 04:25:59PM +0100, Antoine Tenart wrote:
> Document the USB2 ChipIdea driver (ci13xxx) bindings.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> ---
>  .../devicetree/bindings/usb/ci-hdrc-usb2.txt       | 24 ++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt
> 
> diff --git a/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt b/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt
> new file mode 100644
> index 000000000000..27f8b1e5ee46
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt
> @@ -0,0 +1,24 @@
> +* USB2 ChipIdea USB controller for ci13xxx
> +
> +Required properties:
> +- compatible: should be "chipidea,usb2"
> +- reg: base address and length of the registers
> +- interrupts: interrupt for the USB controller
> +
> +Optional properties:
> +- clocks: reference to the USB clock
> +- phys: reference to the USB PHY
> +- phy-names: should be "usb-phy"
> +- vbus-supply: reference to the VBUS regulator
> +
> +Example:
> +
> +	usb@f7ed0000 {
> +		compatible = "chipidea,usb2";
> +		reg = <0xf7ed0000 0x10000>;
> +		interrupts = <GIC_SPI 11 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&chip CLKID_USB0>;
> +		phys = <&usb_phy0>;
> +		phy-names = "usb-phy";
> +		vbus-supply = <&reg_usb0_vbus>;
> +	};
> -- 
> 2.1.0
> 

Acked-by: Peter Chen <peter.chen@freescale.com>

-- 

Best Regards,
Peter Chen
