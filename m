Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaLRI3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 03:29:20 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:58256 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaLRI3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 03:29:17 -0500
Date: Thu, 18 Dec 2014 08:29:08 +0000
From: Lee Jones <lee.jones@linaro.org>
To: gyungoh@gmail.com
Cc: sameo@linux.intel.com, grant.likely@linaro.org, robh+dt@kernel.org,
        jg1.han@samsung.com, cooloney@gmail.com, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, trivial@kernel.org, akpm@linux-foundation.org,
        jic23@kernel.org, thomas.petazzoni@free-electrons.com,
        ktsai@capellamicro.com, hs@denx.de, stwiss.opensource@diasemi.com,
        matti.vaittinen@nsn.com, broonie@kernel.org, jason@lakedaemon.net,
        heiko@sntech.de, shawn.guo@freescale.com, florian.vaussard@epfl.ch,
        andrew@lunn.ch, antonynpavlov@gmail.com, hytszk@gmail.com,
        plagnioj@jcrosoft.com, tomi.valkeinen@ti.com, jack.yoo@skyworksinc.com,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v10 5/6] devicetree: Add vendor prefix for Skyworks
 Solutions, Inc.
Message-ID: <20141218082908.GQ13885@x1>
References: <1418881671-3495-1-git-send-email-jack.yoo@skyworksinc.com>
 <1418881671-3495-6-git-send-email-jack.yoo@skyworksinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1418881671-3495-6-git-send-email-jack.yoo@skyworksinc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2014, gyungoh@gmail.com wrote:

> From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> 
> Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> ---
> Changes v10:
> Nothing
> 
> Changes v9:
> Nothing
> 
> Changes v8:
> Nothing
> 
> Changes v7:
> Nothing
> 
> Changes v6:
> Nothing
> 
> Changes v5:
> Nothing
> 
> Changes v4:
> Nothing
> 
> Changes v3:
> Nothing

Changes v3 => v10:
  Nothing

... might be a little more succinct.
 
> Changes v2:
> Added vendor prefix for Skyworks Solutions, Inc.
> 
>  Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index a344ec2..68143f0 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -140,6 +140,7 @@ sii	Seiko Instruments, Inc.
>  silergy	Silergy Corp.
>  sirf	SiRF Technology, Inc.
>  sitronix	Sitronix Technology Corporation
> +skyworks	Skyworks Solutions, Inc.
>  smsc	Standard Microsystems Corporation
>  snps	Synopsys, Inc.
>  solidrun	SolidRun

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
