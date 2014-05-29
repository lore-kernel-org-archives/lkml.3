Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933924AbaE2Ize (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:55:34 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:54185 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932905AbaE2Iz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:55:28 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7fac6d000006cfe-49-5386f5febdae
Content-transfer-encoding: 8BIT
Message-id: <1401353729.25628.13.camel@AMDC1943>
Subject: Re: [PATCH 4/4] dt-bindings: mfd: s2mps11: Add support S2MPU02 PMIC
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: sbkim73@samsung.com, sameo@linux.intel.com, lee.jones@linaro.org,
        broonie@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        jonghwa3.lee@samsung.com, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, Mark Brown <broonie@linaro.org>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Date: Thu, 29 May 2014 10:55:29 +0200
In-reply-to: <1401275411-21947-5-git-send-email-cw00.choi@samsung.com>
References: <1401275411-21947-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA02RbUiTURiGPXs/9m42OE2Tg5XFJAwpUyo4RET9SF5oUCaBCGFLl4qbs61Z
	FsYMHDqZiSHmnFPzexrCHFhmDGwq8zN1c1BqCkJiMzQ3NU2puR/57+J+7hsueBhCWEOGM5nZ
	j6TKbIlMRPPJ4b1B19k9nzYxdnNGgCsWFmlscbsp7PZ+p3CtfYzCLz31FB5bbgO4eHSRwKMv
	PFz8zdcP8IaziIPrtY0knuox0rjJPcHBXwtaaVxW+ZbEKzOVJC78aOdixx89wMMlFJ5o9XJw
	5+sfJDZW/uRcDWM7TB2AnSrVc9j3hlku29bipdmu1mjWYi6m2ZnpXpo1ORLYUqsZsOuWiFv8
	ZP7lNKksM1eqPHflHj/DuHo3xxz6pLp3ldKAbqgDPAbBC8il3+AGOAx9nuukdYDPCGETQJuF
	PcB/EMDDaOvVHKkDDEPAE8g+meWPCRiFyk1viEB/HSCneZcM9GORzeOj/BwCxWhbs0P4mYbn
	UVdLI+3nUHgaVe06gX9MwGoK7VlL9i1IeAo19A5y/MyD8WjdMr8vIYTX0ZJLQwVMI5HJNsAp
	A9BwwM/w389wwK8OEGZwRKpOzVHdT5fHxagkcpU6Oz0mVSG3gMBLve9Aw8ClPgAZIDokSLqj
	TRRSklxVnrwPIIYQhQp+Tf6LBGmSvKdSpSJFqZZJVX2Aw/DCNSDoNs9pNXKvdQonm+Qh7UFn
	6iLH18TBtg/sl7UU5lNehaBbscM+BssPXHHJ+TWKodmjUUtLN5s33Cu74wXl/TUjIw+zuO3N
	v2utA/nxxhvsvMPK140GxyZoi2RjNqCXNFYN1ifxjpuf2YfE9MXpk3DLJ1YveI5FbIc9T3eI
	SFWGJC6aUKokfwHbbjYasAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-05-28 at 20:10 +0900, Chanwoo Choi wrote:
> This patch add documentation for S2MPU02 PMIC device. S2MPU02 has a little
> difference from S2MPS11/S2MPS14 PMIC and has LDO[1-28]/Buck[1-7].
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Kumar Gala <galak@codeaurora.org>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Mark Brown <broonie@linaro.org>
> Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Yadwinder Singh Brar <yadi.brar@samsung.com>
> Cc: Tomasz Figa <t.figa@samsung.com>
> Cc: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: devicetree@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> 
> ---
> Documentation/devicetree/bindings/mfd/s2mps11.txt | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

Although I'm not a DT maintainer but this looks fine to me, so:
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

> 
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

