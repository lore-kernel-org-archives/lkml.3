Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbaIDNWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 09:22:17 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56123 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbaIDNWO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 09:22:14 -0400
From: "Murphy, Dan" <dmurphy@ti.com>
To: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "sergei.shtylyov@cogentembedded.com" 
	<sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v2 1/2] doc: dt/bindings: input: introduce TI DRV2667
 haptic driver description
Thread-Topic: [PATCH v2 1/2] doc: dt/bindings: input: introduce TI DRV2667
 haptic driver description
Thread-Index: AQHPwHkALSGUIn9lmUKCrHajIRhdvw==
Date: Thu, 4 Sep 2014 13:21:48 +0000
Message-ID: <00FC9A978A94B7418C33AFAE8A35ED49E385C5@DFLE09.ent.ti.com>
References: <1408980413-8763-1-git-send-email-dmurphy@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bumping x2

On 08/25/2014 10:26 AM, Murphy, Dan wrote:
> DRV2667 is a haptic/vibrator driver for Linear Resonant Actuators.
> Adding dt binding for this part
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
> 
> v2 - Removed extra tabs, changed node to function not device
> added vbat-supply, and removed confusing description - https://patchwork.kernel.org/patch/4759381/
> 
>  .../devicetree/bindings/input/ti,drv2667.txt       |   17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/input/ti,drv2667.txt
> 
> diff --git a/Documentation/devicetree/bindings/input/ti,drv2667.txt b/Documentation/devicetree/bindings/input/ti,drv2667.txt
> new file mode 100644
> index 0000000..996382c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/input/ti,drv2667.txt
> @@ -0,0 +1,17 @@
> +* Texas Instruments - drv2667 Haptics driver
> +
> +Required properties:
> +	- compatible - "ti,drv2667" - DRV2667
> +	- reg -  I2C slave address
> +	- vbat-supply - Required supply regulator
> +
> +Example:
> +
> +haptics: haptics@59 {
> +	compatible = "ti,drv2667";
> +	reg = <0x59>;
> +	vbat-supply = <&vbat>;
> +};
> +
> +For more product information please see the link below:
> +http://www.ti.com/product/drv2667
> 


-- 
------------------
Dan Murphy
