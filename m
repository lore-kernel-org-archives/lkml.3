Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaJTMWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:22:49 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:54285 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbaJTMWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:22:46 -0400
Date: Mon, 20 Oct 2014 14:22:45 +0200
From: Ludovic Desroches <ludovic.desroches@atmel.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, Chris Ball <chris@printf.net>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>
Subject: Re: [PATCHv2 0/3] Remove mach/atmel-mci.h
Message-ID: <20141020122245.GA7443@ldesroches-Latitude-E6320>
Mail-Followup-To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
	Nicolas Ferre <nicolas.ferre@atmel.com>,
	Chris Ball <chris@printf.net>,
	Hans-Christian Egtvedt <egtvedt@samfundet.no>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Haavard Skinnemoen <hskinnemoen@gmail.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mmc@vger.kernel.org
References: <1413534398-22645-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1413534398-22645-1-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2014 at 10:26:35AM +0200, Alexandre Belloni wrote:
> This patch series removes the uses of mach/atmel-mci.h and the files themselves.
> The final goal is to be able to switch AT91 to multiplatform.
> 
> The first patch introduces a new platform_data file and uses it in the driver.
> The two following patches remove the uses of mach/atmel-mci.h and the header
> itself from avR32 and ARM/at91.
> 
> Changes in v2:
>  - include back linux/atmel-mci.h and really remove mach/atmel-mci.h in at91sam9g45_devices.c

s/move mache header/move mach header. Otherwise, for the whole series:

Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>

> 
> Alexandre Belloni (3):
>   mmc: atmel-mci: move mache header to platform_data
>   ARM: at91: remove mach/atmel-mci.h
>   avr32: remove mach/atmel-mci.h
> 
>  arch/arm/mach-at91/at91sam9g45_devices.c        |  2 +-
>  arch/arm/mach-at91/include/mach/atmel-mci.h     | 17 -----------------
>  arch/avr32/mach-at32ap/at32ap700x.c             |  2 +-
>  arch/avr32/mach-at32ap/include/mach/atmel-mci.h | 17 -----------------
>  drivers/mmc/host/atmel-mci.c                    |  2 +-
>  include/linux/platform_data/mmc-atmel-mci.h     | 22 ++++++++++++++++++++++
>  6 files changed, 25 insertions(+), 37 deletions(-)
>  delete mode 100644 arch/arm/mach-at91/include/mach/atmel-mci.h
>  delete mode 100644 arch/avr32/mach-at32ap/include/mach/atmel-mci.h
>  create mode 100644 include/linux/platform_data/mmc-atmel-mci.h
> 
> -- 
> 1.9.1
> 
