Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaKCRHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:07:55 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:43068 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbaKCRHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:07:52 -0500
Date: Mon, 3 Nov 2014 17:07:43 +0000
From: Lee Jones <lee.jones@linaro.org>
To: gyungoh@gmail.com
Cc: sameo@linux.intel.com, jg1.han@samsung.com, cooloney@gmail.com,
        broonie@kernel.org, lgirdwood@gmail.com, jack.yoo@skyworksinc.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Subject: Re: [RESUBMIT PATCH v6 5/8] devicetree: Add vendor prefix for
 Skyworks Solutions, Inc.
Message-ID: <20141103170743.GF12011@x1>
References: <1414393369-31583-1-git-send-email-jack.yoo@skyworksinc.com>
 <1414739322-12487-1-git-send-email-jack.yoo@skyworksinc.com>
 <1414739322-12487-6-git-send-email-jack.yoo@skyworksinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414739322-12487-6-git-send-email-jack.yoo@skyworksinc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2014, gyungoh@gmail.com wrote:

> From: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> 
> Signed-off-by: Gyungoh Yoo <jack.yoo@skyworksinc.com>
> ---
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
> 
> Changes v2:
> Added vendor prefix for Skyworks Solutions, Inc.
> 
>  Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
>  1 file changed, 1 insertion(+)

Acked-by: Lee Jones <lee.jones@linaro.org>

> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index 723999d..03e7730 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -137,6 +137,7 @@ sii	Seiko Instruments, Inc.
>  silergy	Silergy Corp.
>  sirf	SiRF Technology, Inc.
>  sitronix	Sitronix Technology Corporation
> +skyworks	Skyworks Solutions, Inc.
>  smsc	Standard Microsystems Corporation
>  snps 	Synopsys, Inc.
>  solidrun	SolidRun

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
