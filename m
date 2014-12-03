Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933679AbaLCAaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:30:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:61880 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933514AbaLCAan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:30:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="424309386"
Date: Wed, 3 Dec 2014 08:30:50 +0800
From: Huang Shijie <shijie.huang@intel.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, Huang Shijie <shijie8@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] mtd: nand: gpmi: remove deprecated comment
Message-ID: <20141203003050.GA7869@shldeISGChi005.sh.intel.com>
References: <1417545429-11283-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417545429-11283-1-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 07:37:09PM +0100, Boris Brezillon wrote:
> Now that we have raw functions properly implemented we can remove this
> FIXME.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
> ---
>  drivers/mtd/nand/gpmi-nand/gpmi-nand.c | 8 --------
>  1 file changed, 8 deletions(-)
> 
> diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
> index 4f3851a..5d2cc9e 100644
> --- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
> +++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
> @@ -1294,14 +1294,6 @@ exit_auxiliary:
>   * ecc.read_page or ecc.read_page_raw function. Thus, the fact that MTD wants an
>   * ECC-based or raw view of the page is implicit in which function it calls
>   * (there is a similar pair of ECC-based/raw functions for writing).
> - *
> - * FIXME: The following paragraph is incorrect, now that there exist
> - * ecc.read_oob_raw and ecc.write_oob_raw functions.
> - *
> - * Since MTD assumes the OOB is not covered by ECC, there is no pair of
> - * ECC-based/raw functions for reading or or writing the OOB. The fact that the
> - * caller wants an ECC-based or raw view of the page is not propagated down to
> - * this driver.
>   */
>  static int gpmi_ecc_read_oob(struct mtd_info *mtd, struct nand_chip *chip,
>  				int page)
Acked-by: Huang Shijie <shijie.huang@intel.com>	
