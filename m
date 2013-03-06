Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab3CFNgy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:36:54 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:60006 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756602Ab3CFNgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:36:50 -0500
Date: Wed, 6 Mar 2013 08:37:17 -0500
From: Matt Porter <mporter@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux OMAP List <linux-omap@vger.kernel.org>, Balaji T K <balajitk@ti.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Dan Williams <djbw@fb.com>, Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH v2 0/3] omap_hsmmc DT DMA Client support
Message-ID: <20130306133717.GJ6209@beef>
References: <1362518004-7083-1-git-send-email-mporter@ti.com>
 <201303052126.01572.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201303052126.01572.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 05, 2013 at 09:26:01PM +0000, Arnd Bergmann wrote:
> On Tuesday 05 March 2013, Matt Porter wrote:
> > Changes since v1:
> >         - rebase to 3.9-rc1, previous dependencies upstream
> > 
> > This series adds DT DMA Engine Client support to the omap_hsmmc.
> > It leverages the generic DMA OF helpers in -next and the
> > dma_request_slave_channel_compat() wrapper introduced in the
> > AM33XX DMA Engine series to support DMA in omap_hsmmc on platforms
> > booting via DT. These platforms include omap2/3/4/5 and am33xx.
> > 
> > These patches were split out from the v5 version of the AM33XX DMA
> > series and split from the EDMA-specific omap_hsmmc changes.
> > 
> 
> The description seems stale, but the patches all look good to me.
> 
> I guess they can now get merged in any order.
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Yes, missed updating that to indicating that those are now in
3.9-rc1.

-Matt
