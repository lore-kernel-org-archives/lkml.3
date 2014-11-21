Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbaKUBOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 20:14:19 -0500
Received: from mga03.intel.com ([134.134.136.65]:31009 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756640AbaKUBOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 20:14:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,426,1413270000"; 
   d="scan'208";a="611528197"
Date: Fri, 21 Nov 2014 09:13:48 +0800
From: Huang Shijie <shijie.huang@intel.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Huang Shijie <shijie8@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, Roy Lee <roylee@paypal.com>,
        Mike Voytovich <mvoytovich@paypal.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 1/4] mtd: nand: provide detailed description for raw
 read/write page methods
Message-ID: <20141121011348.GA28861@shldeISGChi005.sh.intel.com>
References: <1413794777-32220-1-git-send-email-boris.brezillon@free-electrons.com>
 <1413794777-32220-2-git-send-email-boris.brezillon@free-electrons.com>
 <20141120080627.GB3212@norris-Latitude-E6410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120080627.GB3212@norris-Latitude-E6410>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 12:06:27AM -0800, Brian Norris wrote:
> On Mon, Oct 20, 2014 at 10:46:14AM +0200, Boris Brezillon wrote:
> > read_page_raw and write_page_raw method description is not clear enough.
> > It clearly specifies that ECC correction should not be involved but does
> > not talk about specific layout (by layout I mean where in-band and
> > out-of-band data are stored on the NAND media) used by NAND/ECC
> > controllers.
> > 
> > Those specific layouts might impact MTD users and thus should be hidden (as
> > already done in the standard NAND_ECC_HW_SYNDROME implementation).
> > 
> > Clearly state this constraint in the nand_ecc_ctrl struct documentation.
> > 
> > Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> 
> Pushed this patch to l2-mtd.git. Thanks!
thanks.

I am really happy you can merge this patch.

Huang Shijie
