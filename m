Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932137AbaJNInd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 04:43:33 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:57039 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987AbaJNIn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 04:43:29 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-08-543ce22dca97
Message-id: <543CE22A.1080605@samsung.com>
Date: Tue, 14 Oct 2014 10:43:22 +0200
From: =?UTF-8?B?S3J6eXN6dG9mIEtvesWCb3dza2k=?= <k.kozlowski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Thomas Abraham <thomas.ab@samsung.com>, lee.jones@linaro.org,
        devicetree-discuss@lists.ozlabs.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: mfd: s2mps11: add documentation for
 s2mps15 PMIC
References: <1413274468-8765-1-git-send-email-thomas.ab@samsung.com>
 <1413274468-8765-2-git-send-email-thomas.ab@samsung.com>
In-reply-to: <1413274468-8765-2-git-send-email-thomas.ab@samsung.com>
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t/xy7q6j2xCDPZ84bI4MPshq8X8I+dY
	LV6/MLToXXCVzeL+16OMFpd3zWGz6FjG6MDucefaHjaP8zMWMnr0bVnF6PF5k1wASxSXTUpq
	TmZZapG+XQJXxqNrDcwFewQrzq5ezdLA+Ii3i5GTQ0LARGLBseOsELaYxIV769m6GLk4hASW
	Mkp8/PWAHcL5zCixaeZxpi5GDg5eAS2Jn4d8QBpYBFQletrvMoLYbAIeEtO+9zCD2KICERIn
	7+5hB7F5BQQlfky+xwLSKiKQLjFjbgJImFkgVGJK42KwEmGg8uste8FuEBKol9hzqQ1sDKeA
	q8TeJ7MZQVqZBdQlpkzJhWiVl9i85i3zBEaBWUgWzEKomoWkagEj8ypG0dTS5ILipPRcI73i
	xNzi0rx0veT83E2MkID+uoNx6TGrQ4wCHIxKPLwFkTYhQqyJZcWVuYcYJTiYlUR4jRcChXhT
	EiurUovy44tKc1KLDzEycXBKNTCeT5zGWec5YXJ4dUQ4e1/ui38NP9+JR902t1fm+rB/3wSJ
	YI25lmEpW67O1T2YsvykCt/usw7z1k1/wPtI3uvBckEu69mdzLZTUoT2h73+n/q0aWLnak3v
	dbqTPth/rhWeYyG4wqB4izP/5GazGJkbG85ntJyp9OtIEEw9EZTxx6dR1viz6nQlluKMREMt
	5qLiRAD40VktRgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.10.2014 10:14, Thomas Abraham wrote:
> Add dt-binding documentation for s2mps15 PMIC device. The s2mps15 device
> is similar to s2mps11/14 PMIC device and has 27 LDO and 10 buck regulators.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Thomas Abraham <thomas.ab@samsung.com>
> ---
>  Documentation/devicetree/bindings/mfd/s2mps11.txt |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)

Looks good.
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

P.S. Wrong devicetree-discuss@lists.ozlabs.org list? I receive bounces.

Best regards,
Krzysztof


> 
> diff --git a/Documentation/devicetree/bindings/mfd/s2mps11.txt b/Documentation/devicetree/bindings/mfd/s2mps11.txt
> index 0e4026a..41ee3f5 100644
> --- a/Documentation/devicetree/bindings/mfd/s2mps11.txt
> +++ b/Documentation/devicetree/bindings/mfd/s2mps11.txt
> @@ -1,5 +1,5 @@
>  
> -* Samsung S2MPS11, S2MPS14 and S2MPU02 Voltage and Current Regulator
> +* Samsung S2MPS11/14/15 and S2MPU02 Voltage and Current Regulator
>  
>  The Samsung S2MPS11 is a multi-function device which includes voltage and
>  current regulators, RTC, charger controller and other sub-blocks. It is
> @@ -7,8 +7,11 @@ interfaced to the host controller using an I2C interface. Each sub-block is
>  addressed by the host system using different I2C slave addresses.
>  
>  Required properties:
> -- compatible: Should be "samsung,s2mps11-pmic" or "samsung,s2mps14-pmic"
> -              or "samsung,s2mpu02-pmic".
> +- compatible: Should be one of the following
> +	- "samsung,s2mps11-pmic"
> +	- "samsung,s2mps14-pmic"
> +	- "samsung,s2mps15-pmic"
> +	- "samsung,s2mpu02-pmic"
>  - reg: Specifies the I2C slave address of the pmic block. It should be 0x66.
>  
>  Optional properties:
> @@ -82,12 +85,14 @@ as per the datasheet of s2mps11.
>  		  - valid values for n are:
>  			- S2MPS11: 1 to 38
>  			- S2MPS14: 1 to 25
> +			- S2MPS15: 1 to 27
>  			- S2MPU02: 1 to 28
>  		  - Example: LDO1, LDO2, LDO28
>  	- BUCKn
>  		  - valid values for n are:
>  			- S2MPS11: 1 to 10
>  			- S2MPS14: 1 to 5
> +			- S2MPS15: 1 to 10
>  			- S2MPU02: 1 to 7
>  		  - Example: BUCK1, BUCK2, BUCK9
>  
> 

