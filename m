Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbaKDG0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 01:26:10 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:36684 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaKDG0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 01:26:07 -0500
Message-ID: <5458714D.4060107@ti.com>
Date: Tue, 4 Nov 2014 11:55:17 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Lior Amsalem <alior@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Mark Rutland <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/6] ARM: mvebu: add Device Tree description of USB
 cluster controller on Armada 375
References: <1414164254-13053-1-git-send-email-gregory.clement@free-electrons.com> <1414164254-13053-6-git-send-email-gregory.clement@free-electrons.com>
In-Reply-To: <1414164254-13053-6-git-send-email-gregory.clement@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Friday 24 October 2014 08:54 PM, Gregory CLEMENT wrote:
> On Armada 375, the USB cluster allows to control the cluster composed
> of the USB2 and USB3 host controllers.
> 
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  arch/arm/boot/dts/armada-375.dtsi | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/armada-375.dtsi b/arch/arm/boot/dts/armada-375.dtsi
> index de6571445cef..8f45cf5d2a50 100644
> --- a/arch/arm/boot/dts/armada-375.dtsi
> +++ b/arch/arm/boot/dts/armada-375.dtsi
> @@ -342,6 +342,12 @@
>  				#clock-cells = <1>;
>  			};
>  
> +			usbcluster: usb-cluster@18400 {
> +				compatible = "marvell,armada-375-usb-cluster";
> +				reg = <0x18400 0x4>;
> +				#phy-cells = <1>;
> +			};
> +
>  			mbusc: mbus-controller@20000 {
>  				compatible = "marvell,mbus-controller";
>  				reg = <0x20000 0x100>, <0x20180 0x20>;
> 
