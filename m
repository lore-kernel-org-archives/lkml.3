Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbaGKIbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 04:31:07 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44833 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbaGKIbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 04:31:04 -0400
Date: Fri, 11 Jul 2014 09:30:58 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 RESEND] mfd: arizona: Update DT binding to support
 LDO1 init_data
Message-ID: <20140711083058.GK11948@lee--X1>
References: <1405008249-4370-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405008249-4370-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2014, Charles Keepax wrote:

> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  Documentation/devicetree/bindings/mfd/arizona.txt |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)

These would normally require a DT Ack, but as they don't seem to be
adding anything controversial, I'll just apply them.

> diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt
> index 36a0c3d..fd51988 100644
> --- a/Documentation/devicetree/bindings/mfd/arizona.txt
> +++ b/Documentation/devicetree/bindings/mfd/arizona.txt
> @@ -42,6 +42,14 @@ Optional properties:
>      the chip default will be used.  If present exactly five values must
>      be specified.
>  
> +  - DCVDD-supply : Power supply, only needs to be specified if DCVDD is being
> +    externally supplied. As covered in
> +    Documentation/devicetree/bindings/regulator/regulator.txt
> +
> +Optional subnodes:
> +  - ldo1 : Initial data for the LDO1 regulator, as covered in
> +    Documentation/devicetree/bindings/regulator/regulator.txt
> +
>  Example:
>  
>  codec: wm5102@1a {

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
