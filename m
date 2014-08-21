Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbaHUTEV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 15:04:21 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:52065 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595AbaHUTET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 15:04:19 -0400
Message-ID: <53F642AF.3070200@cogentembedded.com>
Date: Thu, 21 Aug 2014 23:04:15 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Dan Murphy <dmurphy@ti.com>, linux-input@vger.kernel.org,
        dmitry.torokhov@gmail.com
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] doc: dt/bindings: input: introduce TI DRV2667 haptic
 driver description
References: <1408645143-25690-1-git-send-email-dmurphy@ti.com> <1408645143-25690-2-git-send-email-dmurphy@ti.com>
In-Reply-To: <1408645143-25690-2-git-send-email-dmurphy@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08/21/2014 10:19 PM, Dan Murphy wrote:

> DRV2667 is a haptic/vibrator driver for Linear Resonant Actuators.
> Adding dt binding for this part

> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>   .../devicetree/bindings/input/ti,drv2667.txt       |   18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/input/ti,drv2667.txt

> diff --git a/Documentation/devicetree/bindings/input/ti,drv2667.txt b/Documentation/devicetree/bindings/input/ti,drv2667.txt
> new file mode 100644
> index 0000000..525216d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/input/ti,drv2667.txt
> @@ -0,0 +1,18 @@
> +Texas Instruments - drv2667 Haptics driver
> +
> +The drv2667 uses serial control bus communicates through I2C protocols
> +
> +Required properties:
> +	- compatible - "ti,drv2667" - DRV2667
> +	- reg -  I2C slave address
> +	- vbat-supply - Required supply regulator
> +
> +Example:
> +
> +drv2667: drv2667@59 {

    The ePAPR standard [1] has something to say on this matter:

"The name of a node should be somewhat generic, reflecting the function of the 
device and not its precise programming model."

> +		compatible = "ti,drv2667";

    Indented too much to the right.

> +		reg = <0x59>;

    Still no "vbat-supply"... :-/

> +};
[...]

WBR, Sergei

