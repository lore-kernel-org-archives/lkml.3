Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760674AbaCUKem (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 06:34:42 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:46607 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759943AbaCUKei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 06:34:38 -0400
Date: Fri, 21 Mar 2014 10:34:32 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, sameo@linux.intel.com,
        lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] regulator: arizona-ldo1: Add processing of init_data
 from device tree
Message-ID: <20140321103432.GF15213@lee--X1>
References: <1395224338-3709-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1395224338-3709-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1395224338-3709-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  Documentation/devicetree/bindings/mfd/arizona.txt |    7 +++

I can see why you're doing it like this, but it's probably best to do
all of the document changes in one single (separate) patch.

>  drivers/regulator/arizona-ldo1.c                  |   46 +++++++++++++++++++-
>  2 files changed, 50 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
> index 36a0c3d..9d54c70 100644
> --- a/Documentation/devicetree/bindings/mfd/arizona.txt
> +++ b/Documentation/devicetree/bindings/mfd/arizona.txt
> @@ -42,6 +42,13 @@ Optional properties:
>      the chip default will be used.  If present exactly five values must
>      be specified.
>  
> +  - ldo1 : Initial data for the LDO1 regulator, as covered in
> +    Documentation/devicetree/bindings/regulator/regulator.txt
> +
> +  - DCVDD-supply : Power supply, only needs to be specified if DCVDD is being
> +    externally supplied. As covered in
> +    Documentation/devicetree/bindings/regulator/regulator.txt
> +

Looks fine to me again, but I'd still like a regulator and/or DT guy
to Ack.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
