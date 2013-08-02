Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab3HBOCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:02:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:22817 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461Ab3HBOCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:02:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,801,1367996400"; 
   d="scan'208";a="356261071"
Message-ID: <1375452445.14869.324.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd: nand: omap2: Fix compilation warning
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: "Gupta, Pekon" <pekon@ti.com>
Cc: Olof Johansson <olof@lixom.net>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Date: Fri, 02 Aug 2013 17:07:25 +0300
In-Reply-To: <20980858CB6D3A4BAE95CA194937D5E73E9ED5F3@DBDE04.ent.ti.com>
References: <1374681392-6183-1-git-send-email-olof@lixom.net>
	 <20980858CB6D3A4BAE95CA194937D5E73E9ED5F3@DBDE04.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-24 at 17:48 +0000, Gupta, Pekon wrote:
> Hi Olof,
> 
> > 
> > fb1585bc13b (mtd: nand: omap2: clean-up BCHx_HW and BCHx_SW ECC
> > configurations in device_probe) introduced a warning when the new option
> > is disabled, i.e. with omap2plus_defconfig:
> > 
> > drivers/mtd/nand/omap2.c:1075:13: warning: 'omap3_enable_hwecc_bch'
> > defined but not used [-Wunused-function]
> > 
> > Fix this by rescoping the ifdef. Also remove a redudant #endif/#ifdef
> > pair.
> > 
> > Signed-off-by: Olof Johansson <olof@lixom.net>
> > ---
> 
> Thanks much..
> But just to remind, this commit fb1585b in linux-next needs to be reverted.
> This patch is leftover by mistake because other dependent patches of 
> this series were dropped. This will not only break omap2-nand driver,
> but might also break the build.

Just dropped it, thanks!

-- 
Best Regards,
Artem Bityutskiy

