Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149Ab3EVSBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 14:01:21 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:64957 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3EVSBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 14:01:19 -0400
Date: Wed, 22 May 2013 14:01:14 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Christian Daudt <csd@broadcom.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>, Chris Ball <cjb@laptop.org>,
        Stephen Warren <swarren@nvidia.com>, Olof Johansson <olof@lixom.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wei WANG <wei_wang@realsil.com.cn>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        csd_b@daudt.org
Subject: Re: [PATCH V2 2/2] ARM: mmc: bcm281xx SDHCI driver (dt mods)
Message-ID: <20130522180114.GA8235@beef>
References: <1368200883-15668-1-git-send-email-csd@broadcom.com>
 <1368200883-15668-2-git-send-email-csd@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368200883-15668-2-git-send-email-csd@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christian,

On Fri, May 10, 2013 at 08:48:03AM -0700, Christian Daudt wrote:
> Add SDHCI driver for the Broadcom 281xx SoCs. Also
> add bindings for it into bcm281xx dts files.

Since this is independent of the driver, the description should probably
be updated to reflect that this is just the DT support for the bcm281xx
(or kona) SDHCI hw.

> Changes from V1:
>  - split original patch into 2, one for driver and this one for dt
> 
> Signed-off-by: Christian Daudt <csd@broadcom.com>
> 
> diff --git a/Documentation/devicetree/bindings/mmc/bcm,kona-sdhci.txt b/Documentation/devicetree/bindings/mmc/bcm,kona-sdhci.txt
> new file mode 100644
> index 0000000..ad1c4bd
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mmc/bcm,kona-sdhci.txt
> @@ -0,0 +1,16 @@
> +Broadcom BCM281xx SDHCI driver

s/driver//

> +
> +This file documents differences between the core properties in mmc.txt
> +and the properties in the bcm281xx driver.

The hardware binding should not mention the supporting driver. Borrowing
from other examples, you'd want something more like:

"
This file documents differences between the core properties described
by mmc.txt and the properties that represent the bcm281xx [kona?] SDHCI.
"

-Matt
