Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab3BFNip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 08:38:45 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:64514 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab3BFNin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 08:38:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Matt Porter <mporter@ti.com>
Subject: Re: [PATCH 0/3] omap_hsmmc DT DMA Client support
Date: Wed, 6 Feb 2013 13:38:31 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-4-generic; KDE/4.3.2; x86_64; ; )
Cc: Venkatraman S <svenkatr@ti.com>, Chris Ball <cjb@laptop.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Tony Lindgren <tony@atomide.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>, Dan Williams <djbw@fb.com>,
        Jon Hunter <jon-hunter@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
References: <1359752479-29427-1-git-send-email-mporter@ti.com>
In-Reply-To: <1359752479-29427-1-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302061338.31241.arnd@arndb.de>
X-Provags-ID: V02:K0:1lSJtMKuDlRVQecKmqGBYfDQPkqU39LZLczwzHjIm4f
 DLkgrXUXvkor2eBFHD6gqLCTimjKwhO+YKBvqieXTk4d+qbfX4
 yu5JRxhXZYcGGgVhuWzwCEsoIXBoaCZmxw84dwVggpJOYipUQz
 Rklw9r2hn3UIQBVw2JSaZ7lMF+3SwKBiiOonkEzBax+MerhZPS
 0hmTHa9+TfccFbgvbxdwLVKWeNeHh5o2hXMrIutgkpC5BLS73L
 yYNXMZ6PuAMRkvvVA51cul2KkStGwLKONXB5196FNFdjqxqwyf
 wnwhWhTFm4aXgceVoLPkpgmzZkPum8N4YNkN2ygna/Hcv+kq5o
 Aw30F1E+aqVvfcuYCJ3I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 February 2013, Matt Porter wrote:
> 
> This series adds DT DMA Engine Client support to the omap_hsmmc.
> It leverages the generic DMA OF helpers in -next and the
> dma_request_slave_channel_compat() wrapper introduced in the
> AM33XX DMA Engine series to support DMA in omap_hsmmc on platforms
> booting via DT. These platforms include omap2/3/4/5 and am33xx.
> 
> These patches were split out from the v5 version of the AM33XX DMA
> series and split from the EDMA-specific omap_hsmmc changes.
> 
> The series depends on the following patches:
> 
>         - dmaengine DT support and edma dmaengine driver fix from
>           the git://git.infradead.org/users/vkoul/slave-dma.git next
>           branch
>         - dma_request_slave_channel_compat() support
>           https://patchwork.kernel.org/patch/2081671/
> 
> The series with all dependencies can be found at
> https://github.com/ohporter/linux/tree/omap-hsmmc-dt-dmaengine-v1

Nice series,

Acked-by: Arnd Bergmann <arnd@arndb.de>
