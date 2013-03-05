Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab3CEV0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 16:26:17 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:64349 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756765Ab3CEV0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 16:26:14 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Matt Porter <mporter@ti.com>
Subject: Re: [PATCH v2 0/3] omap_hsmmc DT DMA Client support
Date: Tue, 5 Mar 2013 21:26:01 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Balaji T K <balajitk@ti.com>, Chris Ball <cjb@laptop.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Tony Lindgren <tony@atomide.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>, Dan Williams <djbw@fb.com>,
        Jon Hunter <jon-hunter@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
References: <1362518004-7083-1-git-send-email-mporter@ti.com>
In-Reply-To: <1362518004-7083-1-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303052126.01572.arnd@arndb.de>
X-Provags-ID: V02:K0:Zs8hfEY4AFviwDwBBI8yO0aKX0HgcV+LfcLCjpTegK9
 VjvEG9YQ/k2aNBMPsXfnkUbj7EzaU8IfGh2Ou39Oxkm0Kt0ZJZ
 zNljBGnPtY5RTYetKET217A6op/Z/nvYqoNInEePPd8E0ls8va
 M3kKZHmPNTJoTCAzgj0ns7gbMdTJ5J/MCWkurWOyHSzl00R6hP
 qdr+0vDum21e8m/lQHxReqqaJF7yVmRkuvOULZDHo9STIrLfk+
 /UrJJWIYGyisWFPLz7Y3bhbRoOBDWUgBtg+BLXhTnVcyFTYdf5
 4opc+hwu4QWypS8Hw/XS32oX5BTIxnO0pj5KPH9GbD4yppHtQC
 kDkYxmXc2eF/uDJJaUGo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 March 2013, Matt Porter wrote:
> Changes since v1:
>         - rebase to 3.9-rc1, previous dependencies upstream
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

The description seems stale, but the patches all look good to me.

I guess they can now get merged in any order.

Acked-by: Arnd Bergmann <arnd@arndb.de>
