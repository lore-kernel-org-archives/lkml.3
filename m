Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab3BDMIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 07:08:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:21593 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121Ab3BDL47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:56:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,598,1355126400"; 
   d="scan'208";a="282485722"
Date: Mon, 4 Feb 2013 12:56:33 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Roger Tseng <rogerable@realtek.com>
Cc: cjb@laptop.org, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, gregkh@linuxfoundation.org,
        wei_wang@realsil.com.cn
Subject: Re: [PATCH 2/3] mfd: rtsx: implement driving adjustment to
 device-dependent callbacks
Message-ID: <20130204115633.GD8476@sortiz-mobl>
References: <1359963959-2305-1-git-send-email-rogerable@realtek.com>
 <1359963959-2305-3-git-send-email-rogerable@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359963959-2305-3-git-send-email-rogerable@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On Mon, Feb 04, 2013 at 03:45:58PM +0800, Roger Tseng wrote:
> Implement different ways of selecting driving capability(a necessary adjustment
> along with voltage change). It was origionally in device-independent
> mmc/host/rtsx_pci_sdmmc.c. Moving it here to support devices which may have a
> different way of adjustment.
> 
> Signed-off-by: Roger Tseng <rogerable@realtek.com>
> Reviewed-by: Wei WANG <wei_wang@realsil.com.cn>
> ---
>  drivers/mfd/rtl8411.c | 16 +++++++++++++---
>  drivers/mfd/rts5209.c |  8 ++++++++
>  drivers/mfd/rts5229.c |  8 ++++++++
>  3 files changed, 29 insertions(+), 3 deletions(-)
Applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
