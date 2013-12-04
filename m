Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab3LDGJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 01:09:16 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:56856 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753581Ab3LDGJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 01:09:14 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(z579ehz98dI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h17326ah8275bh8275dh1de097h186068hz2dh2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1155h)
Date: Wed, 4 Dec 2013 13:40:04 +0800
From: Peter Chen <peter.chen@freescale.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: <alexander.shishkin@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <davidb@codeaurora.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/4] usb: chipidea: msm: Add device tree binding
 information
Message-ID: <20131204054003.GB29552@shlinux1.ap.freescale.net>
References: <1384176937-1658-1-git-send-email-iivanov@mm-sol.com>
 <1384176937-1658-2-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1384176937-1658-2-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 03:35:34PM +0200, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 

Please add something in commit log

> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> Cc: devicetree@vger.kernel.org
> ---
>  .../devicetree/bindings/usb/msm-hsusb.txt          |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/usb/msm-hsusb.txt b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
> index 5ea26c6..0a85eba 100644
> --- a/Documentation/devicetree/bindings/usb/msm-hsusb.txt
> +++ b/Documentation/devicetree/bindings/usb/msm-hsusb.txt
> @@ -15,3 +15,19 @@ Example EHCI controller device node:
>  		usb-phy = <&usb_otg>;
>  	};
>  
> +CI13xxx (Chipidea) USB controllers
> +

We have already renamed ci13xxx to ci_hdrc.

> +Required properties:
> +- compatible: 	should contain "qcom,ci-hdrc"
> +- reg: 			offset and length of the register set in the memory map
> +- interrupts: 	interrupt-specifier for the controller interrupt.
> +- usb-phy:		phandle for the PHY device
> +- dr_mode: 		Sould be "peripheral"
> +

Please keep alignment for "reg"

Peter

> +	gadget@f9a55000 {
> +		compatible = "qcom,ci-hdrc";
> +		reg = <0xf9a55000 0x400>;
> +		dr_mode = "peripheral";
> +		interrupts = <0 134 0>;
> +		usb-phy = <&usb_otg>;
> +	};
> \ No newline at end of file
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 

Best Regards,
Peter Chen

