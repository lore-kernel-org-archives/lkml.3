Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbaIKBJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 21:09:36 -0400
Received: from mail-by2on0126.outbound.protection.outlook.com ([207.46.100.126]:9584
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751931AbaIKBJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 21:09:34 -0400
Date: Thu, 11 Sep 2014 09:09:25 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
CC: <sebastian.hesselbarth@gmail.com>, <balbi@ti.com>,
        <p.zabel@pengutronix.de>, <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 08/12] Documentation: bindings: add doc for the USB2
 ChipIdea USB driver
Message-ID: <20140911010924.GF3609@peterchendt>
References: <1409730511-16101-1-git-send-email-antoine.tenart@free-electrons.com>
 <1409730511-16101-9-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1409730511-16101-9-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(51704005)(24454002)(19580405001)(68736004)(21056001)(83322001)(46406003)(19580395003)(44976005)(6806004)(33656002)(83506001)(57986006)(84676001)(85306004)(77982001)(46102001)(79102001)(76482001)(102836001)(26826002)(105606002)(104016003)(106466001)(64706001)(20776003)(47776003)(90102001)(107046002)(81342001)(4396001)(50466002)(74502001)(74662001)(80022001)(31966008)(83072002)(85852003)(92726001)(92566001)(86362001)(95666004)(97736003)(50986999)(76176999)(33716001)(110136001)(81542001)(99396002)(54356999)(23726002)(97756001)(87936001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB209;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03319F6FEF
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2014 at 09:48:27AM +0200, Antoine Tenart wrote:
> Document the USB2 ChipIdea driver (ci13xxx) bindings.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> ---
>  .../devicetree/bindings/usb/ci-hdrc-usb2.txt       | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt
> 
> diff --git a/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt b/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt
> new file mode 100644
> index 000000000000..8dd6d8285dab
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt
> @@ -0,0 +1,22 @@
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
> +		vbus-supply = <&reg_usb0_vbus>;
> +	};
> -- 
> 1.9.1
> 

This one is ok for me.

-- 
Best Regards,
Peter Chen
