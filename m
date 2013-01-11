Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755695Ab3AKSPp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 13:15:45 -0500
Received: from smtp2.goneo.de ([212.90.139.82]:39524 "EHLO smtp2.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755556Ab3AKSOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 13:14:07 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.897
From: Lars Poeschel <poeschel@lemonage.de>
To: Matt Porter <mporter@ti.com>
Subject: Re: [PATCH v4,03/14] ARM: edma: add AM33XX support to the private EDMA API
Date: Fri, 11 Jan 2013 19:14:27 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
References: <1357883330-5364-4-git-send-email-mporter@ti.com>
In-Reply-To: <1357883330-5364-4-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201301111914.27712.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On Friday 11 January 2013 at 06:48:39, Matt Porter wrote:

> diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
> index a3d189d..1951d63 100644
> --- a/arch/arm/common/edma.c
> +++ b/arch/arm/common/edma.c
> @@ -24,6 +24,13 @@
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
>  #include <linux/slab.h>
> +#include <linux/edma.h>
> +#include <linux/err.h>
> +#include <linux/of_address.h>
> +#include <linux/of_device.h>
> +#include <linux/of_dma.h>
> +#include <linux/of_irq.h>
> +#include <linux/pm_runtime.h>

You add the include linux/of_dma.h here, but maybe you missed to add the file 
itself. It is not in Linus v3.8-rc3 tree, not in the patches yours depend on 
listed and not in your patchset.

Regards,
Lars
