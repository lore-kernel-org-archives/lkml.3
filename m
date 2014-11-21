Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbaKUBUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 20:20:15 -0500
Received: from mga01.intel.com ([192.55.52.88]:47702 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756487AbaKUBUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 20:20:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="419599791"
Date: Fri, 21 Nov 2014 09:19:28 +0800
From: Huang Shijie <shijie.huang@intel.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Huang Shijie <shijie8@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, Roy Lee <roylee@paypal.com>,
        Mike Voytovich <mvoytovich@paypal.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 0/4] mtd: nand: gpmi: add proper raw access support
Message-ID: <20141121011928.GB28861@shldeISGChi005.sh.intel.com>
References: <1413794777-32220-1-git-send-email-boris.brezillon@free-electrons.com>
 <20141120092336.GE3212@norris-Latitude-E6410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120092336.GE3212@norris-Latitude-E6410>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 01:23:36AM -0800, Brian Norris wrote:
> On Mon, Oct 20, 2014 at 10:46:13AM +0200, Boris Brezillon wrote:
> > This series provides an implementation for raw accesses taking care of
> > hidding the specific layout used by the GPMI controller.
> > 
> > I also updated the nand_ecc_ctrl struct documentation to clearly state that
> > specific layouts should be hidden when accessing the NAND chip in raw mode.
> 
> Can I get any ack's, tested-by's, or reviewed-by's?
> 
I will add my tested-by in the Boris's next release.

thanks
Huang Shijie
