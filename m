Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab3BDL5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:57:15 -0500
Received: from mga14.intel.com ([143.182.124.37]:55169 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754961Ab3BDL5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:57:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,598,1355126400"; 
   d="scan'208";a="252300815"
Date: Mon, 4 Feb 2013 12:57:04 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Roger Tseng <rogerable@realtek.com>
Cc: cjb@laptop.org, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, gregkh@linuxfoundation.org,
        wei_wang@realsil.com.cn
Subject: Re: [PATCH 3/3] mfd: rtsx: support RTS5227
Message-ID: <20130204115704.GE8476@sortiz-mobl>
References: <1359963959-2305-1-git-send-email-rogerable@realtek.com>
 <1359963959-2305-4-git-send-email-rogerable@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359963959-2305-4-git-send-email-rogerable@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On Mon, Feb 04, 2013 at 03:45:59PM +0800, Roger Tseng wrote:
> Support new model RTS5227.
> 
> Signed-off-by: Roger Tseng <rogerable@realtek.com>
> Reviewed-by: Wei WANG <wei_wang@realsil.com.cn>
> ---
>  drivers/mfd/Makefile         |   2 +-
>  drivers/mfd/rts5227.c        | 234 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/mfd/rtsx_pcr.c       |   5 +
>  drivers/mfd/rtsx_pcr.h       |   1 +
>  include/linux/mfd/rtsx_pci.h |   5 +
>  5 files changed, 246 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/mfd/rts5227.c
Applied as well, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
