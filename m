Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab3KAUyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 16:54:33 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:3033 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446Ab3KAUyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 16:54:31 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <527414F2.7090402@broadcom.com>
Date: Fri, 1 Nov 2013 21:54:10 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.0
MIME-Version: 1.0
To: "Matt Porter" <matt.porter@linaro.org>, "Felipe Balbi" <balbi@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Kishon Vijay Abraham I" <kishon@ti.com>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Kumar Gala" <galak@codeaurora.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Christian Daudt" <bcm@fixthebug.org>,
        "Paul Zimmerman" <paulz@synopsys.com>
cc: "Linux USB List" <linux-usb@vger.kernel.org>,
        "Linux ARM Kernel List" <linux-arm-kernel@lists.infradead.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Devicetree List" <devicetree@vger.kernel.org>,
        "Linaro Patches" <patches@linaro.org>
Subject: Re: [PATCH v2 7/9] phy: add Broadcom Kona USB2 PHY DT binding
References: <1383335158-19730-1-git-send-email-matt.porter@linaro.org>
 <1383335158-19730-8-git-send-email-matt.porter@linaro.org>
In-Reply-To: <1383335158-19730-8-git-send-email-matt.porter@linaro.org>
X-WSS-ID: 7E6ACB781503931726-02-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2013 08:45 PM, Matt Porter wrote:
> Add a binding that describes the Broadcom Kona USB2 PHY found
> on the BCM281xx family of SoCs.
>
> Signed-off-by: Matt Porter <matt.porter@linaro.org>
> ---
>   .../devicetree/bindings/phy/bcm-kona-usb2-phy.txt         | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/phy/bcm-kona-usb2-phy.txt
>
> diff --git a/Documentation/devicetree/bindings/phy/bcm-kona-usb2-phy.txt b/Documentation/devicetree/bindings/phy/bcm-kona-usb2-phy.txt
> new file mode 100644
> index 0000000..db309e2
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/bcm-kona-usb2-phy.txt
> @@ -0,0 +1,15 @@
> +BROADCOM KONA USB2 PHY
> +
> +Required properties:
> + - compatible: brcm,kona-usb2-phy
> + - regs: offset and length of the PHY registers
> + - #phy-cells: must be 0
> +Refer to phy/phy-bindings.txt for the generic PHY binding properties
> +
> +Example:
> +
> +	usbphy: usbphy@3f130000 {
> +		compatible = "brcm,kona-usb2-phy";
> +		reg = <0x3f130000 0x28>;

I expect 'regs' iso 'reg' in this example.

Regards,
Arend

> +		#phy-cells = <0>;
> +	};
>


