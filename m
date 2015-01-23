Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbbAWTY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 14:24:28 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:48525 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbbAWTY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 14:24:26 -0500
Message-ID: <54C29FE8.8080905@infradead.org>
Date: Fri, 23 Jan 2015 11:24:24 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, trivial@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [trivial] treewide: Fix typo in printk messages
References: <1421931414-24426-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1421931414-24426-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/15 04:56, Masanari Iida wrote:
> This patch fix spelling typo in printk messages.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  arch/powerpc/perf/hv-24x7.c                      | 2 +-
>  drivers/clk/samsung/clk.c                        | 2 +-
>  drivers/gpu/drm/drm_atomic.c                     | 4 ++--
>  drivers/gpu/drm/nouveau/core/engine/graph/nv10.c | 4 ++--
>  drivers/mfd/si476x-i2c.c                         | 2 +-
>  drivers/mmc/core/mmc.c                           | 4 ++--
>  drivers/mmc/core/sd.c                            | 4 ++--
>  drivers/mtd/nand/gpmi-nand/gpmi-lib.c            | 2 +-
>  drivers/net/phy/dp83640.c                        | 2 +-
>  drivers/net/wireless/airo.c                      | 4 ++--
>  drivers/net/wireless/ath/wcn36xx/smd.c           | 2 +-
>  drivers/pinctrl/nomadik/pinctrl-abx500.c         | 2 +-
>  drivers/scsi/ch.c                                | 2 +-
>  drivers/usb/gadget/udc/bdc/bdc_ep.c              | 2 +-
>  fs/jffs2/xattr.c                                 | 2 +-
>  lib/rhashtable.c                                 | 2 +-
>  net/atm/mpoa_proc.c                              | 2 +-
>  sound/soc/soc-core.c                             | 4 ++--
>  18 files changed, 24 insertions(+), 24 deletions(-)


-- 
~Randy
