Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab3BCWcL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 17:32:11 -0500
Received: from mga03.intel.com ([143.182.124.21]:28296 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795Ab3BCWcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 17:32:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,595,1355126400"; 
   d="scan'208";a="198290521"
Date: Sun, 3 Feb 2013 23:32:04 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: wei_wang@realsil.com.cn
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        rogerable@realtek.com
Subject: Re: [PATCH 0/6] MFD:rtsx: Fix coding style and optimize flow
Message-ID: <20130203223204.GX8476@sortiz-mobl>
References: <cover.1359443487.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1359443487.git.wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

On Tue, Jan 29, 2013 at 03:21:31PM +0800, wei_wang@realsil.com.cn wrote:
> From: Wei WANG <wei_wang@realsil.com.cn>
> 
> This patchset fixes some coding style issues, and optimizes card detect
> flow to improve the stability when inserting card.
> 
> Wei WANG (6):
>   MFD:rtsx: Fix typo in comment
>   MFD:rtsx: Remove redundant code
>   MFD:rtsx: Declare that the DMA address limitation is 32bit explicitly
>   MFD:rtsx: Fix checkpatch warning
>   MFD:rtsx: Use macro defines to replace some variables
>   MFD:rtsx: Optimize card detect flow
> 
>  drivers/mfd/rtsx_pcr.c       |   63 +++++++++++++++++++++++-------------------
>  drivers/mfd/rtsx_pcr.h       |    3 ++
>  include/linux/mfd/rtsx_pci.h |    2 +-
>  3 files changed, 38 insertions(+), 30 deletions(-)
All 6 patches applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
