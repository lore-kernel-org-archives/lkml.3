Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbaCEKE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 05:04:28 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:42575 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271AbaCEKET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 05:04:19 -0500
MIME-Version: 1.0
In-Reply-To: <1394011373-4057-4-git-send-email-k.kozlowski@samsung.com>
References: <1394011373-4057-1-git-send-email-k.kozlowski@samsung.com>
	<1394011373-4057-4-git-send-email-k.kozlowski@samsung.com>
Date: Wed, 5 Mar 2014 15:34:18 +0530
Message-ID: <CAK9yfHxFciupJPw9XbVRsBUmY7bUT8L4goGW+TYPwQRUUqsKew@mail.gmail.com>
Subject: Re: [PATCH 3/3] Documentation: mfd: s2mps11: Document support for S2MPS14
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 5 March 2014 14:52, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> Add bindings documentation for S2MPS14 device to the s2mps11 driver.

nit: s/s2mps11/S2MPS11

>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Liam Girdwood <lgirdwood@gmail.com>
> Cc: Tomasz Figa <t.figa@samsung.com>
> Cc: devicetree@vger.kernel.org
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> Acked-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  Documentation/devicetree/bindings/mfd/s2mps11.txt |   12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/mfd/s2mps11.txt b/Documentation/devicetree/bindings/mfd/s2mps11.txt
> index 15ee89c3cc7b..f69bec294f02 100644
> --- a/Documentation/devicetree/bindings/mfd/s2mps11.txt
> +++ b/Documentation/devicetree/bindings/mfd/s2mps11.txt
> @@ -1,5 +1,5 @@
>
> -* Samsung S2MPS11 Voltage and Current Regulator
> +* Samsung S2MPS11 and S2MPS14 Voltage and Current Regulator
>
>  The Samsung S2MPS11 is a multi-function device which includes voltage and
>  current regulators, RTC, charger controller and other sub-blocks. It is
> @@ -7,7 +7,7 @@ interfaced to the host controller using an I2C interface. Each sub-block is
>  addressed by the host system using different I2C slave addresses.
>
>  Required properties:
> -- compatible: Should be "samsung,s2mps11-pmic".
> +- compatible: Should be "samsung,s2mps11-pmic" or "samsung,s2mps14-pmic".
>  - reg: Specifies the I2C slave address of the pmic block. It should be 0x66.
>
>  Optional properties:
> @@ -59,10 +59,14 @@ supports. Note: The 'n' in LDOn and BUCKn represents the LDO or BUCK number
>  as per the datasheet of s2mps11.
>
>         - LDOn
> -                 - valid values for n are 1 to 38
> +                 - valid values for n are:
> +                       - S2MPS11: 1 to 38
> +                       - S2MPS14: 1 to 25
>                   - Example: LDO1, LD02, LDO28
>         - BUCKn
> -                 - valid values for n are 1 to 10.
> +                 - valid values for n are:
> +                       - S2MPS11: 1 to 10
> +                       - S2MPS14: 1 to 5
>                   - Example: BUCK1, BUCK2, BUCK9
>
>  Example:
> --
> 1.7.9.5
>
Looks good.
Acked-by: Sachin Kamat <sachin.kamat@linaro.org>


-- 
With warm regards,
Sachin
