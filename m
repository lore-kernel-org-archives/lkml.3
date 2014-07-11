Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbaGKIcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 04:32:48 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:36948 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaGKIcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 04:32:33 -0400
Date: Fri, 11 Jul 2014 09:32:27 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 RESEND] mfd: arizona: Update DT binding to support
 MICVDD init_data
Message-ID: <20140711083227.GL11948@lee--X1>
References: <1405008249-4370-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1405008249-4370-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405008249-4370-2-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2014, Charles Keepax wrote:

> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  Documentation/devicetree/bindings/mfd/arizona.txt |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
> index fd51988..5c7e723 100644
> --- a/Documentation/devicetree/bindings/mfd/arizona.txt
> +++ b/Documentation/devicetree/bindings/mfd/arizona.txt
> @@ -42,13 +42,15 @@ Optional properties:
>      the chip default will be used.  If present exactly five values must
>      be specified.
>  
> -  - DCVDD-supply : Power supply, only needs to be specified if DCVDD is being
> -    externally supplied. As covered in

Patch 1 in this series just added these two lines.  Normally I'd ask
you to squash them, but as they've been around for a while already and
_might_ have (benefit of the doubt) originated from separate
patch-sets, I'll apply it anyway.

Applied, thanks.

> +  - DCVDD-supply, MICVDD-supply : Power supplies, only need to be specified if
> +    they are being externally supplied. As covered in
>      Documentation/devicetree/bindings/regulator/regulator.txt
>  
>  Optional subnodes:
>    - ldo1 : Initial data for the LDO1 regulator, as covered in
>      Documentation/devicetree/bindings/regulator/regulator.txt
> +  - micvdd : Initial data for the MICVDD regulator, as covered in
> +    Documentation/devicetree/bindings/regulator/regulator.txt
>  
>  Example:
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
