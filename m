Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965751AbaFRJO6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 05:14:58 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:34821 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965237AbaFRJO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 05:14:56 -0400
Date: Wed, 18 Jun 2014 10:14:49 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: broonie@kernel.org, sameo@linux.intel.com, sbkim73@samsung.com,
        k.kozlowski@samsung.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, t.figa@samsung.com,
        sachin.kamat@linaro.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCHv6 3/3] dt-bindings: mfd: s2mps11: Add support S2MPU02 PMIC
Message-ID: <20140618091449.GE23945@lee--X1>
References: <1402964830-24890-1-git-send-email-cw00.choi@samsung.com>
 <1402964830-24890-4-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402964830-24890-4-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jun 2014, Chanwoo Choi wrote:

> This patch add documentation for S2MPU02 PMIC device. S2MPU02 has a little
> difference from S2MPS11/S2MPS14 PMIC and has LDO[1-28]/Buck[1-7].
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  Documentation/devicetree/bindings/mfd/s2mps11.txt | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

Nothing controversial here me thinks.

Applied, thanks.

> diff --git a/Documentation/devicetree/bindings/mfd/s2mps11.txt b/Documentation/devicetree/bindings/mfd/s2mps11.txt
> index d81ba30..f7c9180 100644
> --- a/Documentation/devicetree/bindings/mfd/s2mps11.txt
> +++ b/Documentation/devicetree/bindings/mfd/s2mps11.txt
> @@ -1,5 +1,5 @@
>  
> -* Samsung S2MPS11 and S2MPS14 Voltage and Current Regulator
> +* Samsung S2MPS11, S2MPS14 and S2MPU02 Voltage and Current Regulator
>  
>  The Samsung S2MPS11 is a multi-function device which includes voltage and
>  current regulators, RTC, charger controller and other sub-blocks. It is
> @@ -7,7 +7,8 @@ interfaced to the host controller using an I2C interface. Each sub-block is
>  addressed by the host system using different I2C slave addresses.
>  
>  Required properties:
> -- compatible: Should be "samsung,s2mps11-pmic" or "samsung,s2mps14-pmic".
> +- compatible: Should be "samsung,s2mps11-pmic" or "samsung,s2mps14-pmic"
> +              or "samsung,s2mpu02-pmic".
>  - reg: Specifies the I2C slave address of the pmic block. It should be 0x66.
>  
>  Optional properties:
> @@ -81,11 +82,13 @@ as per the datasheet of s2mps11.
>  		  - valid values for n are:
>  			- S2MPS11: 1 to 38
>  			- S2MPS14: 1 to 25
> +			- S2MPU02: 1 to 28
>  		  - Example: LDO1, LD02, LDO28
>  	- BUCKn
>  		  - valid values for n are:
>  			- S2MPS11: 1 to 10
>  			- S2MPS14: 1 to 5
> +			- S2MPU02: 1 to 7
>  		  - Example: BUCK1, BUCK2, BUCK9
>  
>  Example:

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
