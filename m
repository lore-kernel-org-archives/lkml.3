Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbaIGNfX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 09:35:23 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:53339 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbaIGNfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 09:35:22 -0400
Message-ID: <540C5F16.4000108@cogentembedded.com>
Date: Sun, 07 Sep 2014 17:35:18 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Stefan Wahren <info@lategoodbye.de>, lgirdwood@gmail.com,
        broonie@kernel.org, shawn.guo@linaro.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org
CC: stefan.wahren@i2se.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, festevam@gmail.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC 1/3] DT: add binding for MXS regulator
References: <1410089869-6611-1-git-send-email-info@lategoodbye.de> <1410089869-6611-2-git-send-email-info@lategoodbye.de>
In-Reply-To: <1410089869-6611-2-git-send-email-info@lategoodbye.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 9/7/2014 3:37 PM, Stefan Wahren wrote:

> This patch adds the Device tree bindings for the Freescale MXS on-chip
> regulators.

> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
> ---
>   .../bindings/regulator/mxs-regulator.txt           | 38 ++++++++++++++++++++++
>   1 file changed, 38 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/regulator/mxs-regulator.txt

> diff --git a/Documentation/devicetree/bindings/regulator/mxs-regulator.txt b/Documentation/devicetree/bindings/regulator/mxs-regulator.txt
> new file mode 100644
> index 0000000..c3226cc
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/regulator/mxs-regulator.txt
> @@ -0,0 +1,38 @@
> +MXS regulators
> +
> +Required node properties:
> +- compatible: Should be "fsl,<soc>-power", where soc is "imx23" or "imx28"
> +- reg: Offset and length of the register set for the device
> +
> +Required regulator properties:
> +- compatible: Must be "fsl,mxs-regulator"
> +- reg: Offset of the register set for the regulator
> +- mxs-max-reg-val: Maximum value of this register
> +
> +Optional regulator properties:
> +- mxs-default-microvolt: initial voltage of the regulator

    Vendor specific property names should be prefixed with the vendor name and 
comma.

WBR, Sergei

