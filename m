Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996Ab3FUKis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 06:38:48 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58120 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab3FUKiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 06:38:46 -0400
Message-ID: <51C42CFF.10002@ti.com>
Date: Fri, 21 Jun 2013 16:07:51 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Sourav Poddar <sourav.poddar@ti.com>, Joel A Fernandes <joelagnel@ti.com>,
        Tony Lindgren <tony@atomide.com>, Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>,
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
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v12 09/11] spi: omap2-mcspi: convert to dma_request_slave_channel_compat()
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com> <1371762407-24544-10-git-send-email-joelagnel@ti.com> <51C42A71.1090403@ti.com>
In-Reply-To: <51C42A71.1090403@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing Mark's e-mail.

Mark,

On 6/21/2013 3:56 PM, Sourav Poddar wrote:
> Hi Mark,

> On Friday 21 June 2013 02:36 AM, Joel A Fernandes wrote:
>> From: Matt Porter<mporter@ti.com>
>>
>> Convert dmaengine channel requests to use
>> dma_request_slave_channel_compat(). This supports the DT case of
>> platforms requiring channel selection from either the OMAP DMA or
>> the EDMA engine. AM33xx only boots from DT and is the only user
>> implementing EDMA so in the !DT case we can default to the OMAP DMA
>> filter.
>>
>> Signed-off-by: Matt Porter<mporter@ti.com>
>> Acked-by: Mark Brown<broonie@opensource.wolfsonmicro.com>
>> Signed-off-by: Joel A Fernandes<joelagnel@ti.com>

[...]

> Acked-by: Sourav Poddar <sourav.poddar@ti.com>
> Tested-by: Sourav Poddar <sourav.poddar@ti.com>
> 
> This patch can go independently and does not depend on the rest of the
> series.
> Can these patch be pulled?

We can resend the patch if you don't have it from the mailing list.

Thanks,
Sekhar
