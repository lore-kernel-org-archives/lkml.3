Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753AbaAMKVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 05:21:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:20552 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613AbaAMKV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:21:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,651,1384329600"; 
   d="scan'208";a="437949767"
Date: Mon, 13 Jan 2014 14:50:21 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Nicolin Chen <Guangyu.Chen@freescale.com>, dan.j.williams@intel.com,
        kernel@pengutronix.de, fabio.estevam@freescale.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] Revert "ARM: dts: imx: use dual-fifo sdma script
 for ssi"
Message-ID: <20140113092021.GD25466@intel.com>
References: <1389170756-22351-1-git-send-email-Guangyu.Chen@freescale.com>
 <1389170756-22351-2-git-send-email-Guangyu.Chen@freescale.com>
 <20140110024359.GB6844@S2101-09.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140110024359.GB6844@S2101-09.ap.freescale.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 10:44:03AM +0800, Shawn Guo wrote:
> On Wed, Jan 08, 2014 at 04:45:55PM +0800, Nicolin Chen wrote:
> > This reverts commit b1d27c79c8377df1880447375deffa3bb82c7bd3.
> > 
> > Previously we switched the SSI scriprt to dual-fifo mode to reduce playback
> > underrun issue, which is only included by SDMA firmware version 2. However,
> > there are quite a lot people still using version 1 or default firmware in
> > the ROM code of SoC while these two kinds of firmwares do not support the
> > dual-fifo script and the audio function on their platform would be broken.
> > 
> > Thus this patch provisionally reverts the dual-fifo script to the original
> > single fifo script to meet all kinds of users' requirements, including the
> > version 1/2 or inner ROM firmware.
> > 
> > Reported-by: Fabio Estevam <fabio.estevam@freescale.com>
> > Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
> 
> If Vinod's tree can be rebased, the patch can just be dropped.
Nope dont want Linus's ire due to rebaseing tree so late in cyle!

--
~Vinod
> Otherwise,
> 
> Acked-by: Shawn Guo <shawn.guo@linaro.org>
> 

-- 
