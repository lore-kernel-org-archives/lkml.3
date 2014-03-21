Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760554AbaCUK2c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 06:28:32 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:41358 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760120AbaCUK2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 06:28:30 -0400
Date: Fri, 21 Mar 2014 10:28:25 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, sameo@linux.intel.com,
        lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] regulator: arizona-micsupp: Add processing of
 init_data from device tree
Message-ID: <20140321102825.GE15213@lee--X1>
References: <1395224338-3709-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1395224338-3709-6-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395224338-3709-6-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  Documentation/devicetree/bindings/mfd/arizona.txt |    6 ++-
>  drivers/regulator/arizona-micsupp.c               |   50 +++++++++++++++++++++

For the sake of simplicity would you be kind enough to submit MFD
documentation separate from sub-device code please?

>  2 files changed, 54 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
> index 9d54c70..9c685b2 100644
> --- a/Documentation/devicetree/bindings/mfd/arizona.txt
> +++ b/Documentation/devicetree/bindings/mfd/arizona.txt
> @@ -44,9 +44,11 @@ Optional properties:
>  
>    - ldo1 : Initial data for the LDO1 regulator, as covered in
>      Documentation/devicetree/bindings/regulator/regulator.txt
> +  - micvdd : Initial data for the MICVDD regulator, as covered in
> +    Documentation/devicetree/bindings/regulator/regulator.txt
>  
> -  - DCVDD-supply : Power supply, only needs to be specified if DCVDD is being
> -    externally supplied. As covered in
> +  - DCVDD-supply, MICVDD-supply : Power supplies, only need to be specified if
> +    they are being externally supplied. As covered in
>      Documentation/devicetree/bindings/regulator/regulator.txt

Changes looks good to me, but I'd still like Mark's Ack at a minimum,
ideally someone from DT too.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
