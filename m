Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab3LRG5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:57:23 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:32389 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab3LRG5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:57:22 -0500
Date: Wed, 18 Dec 2013 09:53:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: micky_ching@realsil.com.cn
Cc: sameo@linux.intel.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, wei_wang@realsil.com.cn,
        rogerable@realtek.com, devel@linuxdriverproject.org
Subject: Re: [PATCH v4 0/2] mfd: rtsx: decrease driver size and add new device
Message-ID: <20131218065339.GB28413@mwanda>
References: <cover.1387331869.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1387331869.git.micky_ching@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 10:03:11AM +0800, micky_ching@realsil.com.cn wrote:
> From: Micky Ching <micky_ching@realsil.com.cn>
> 
> we add a macro to simplify setting pull control, and use a common init
> function to init the common params for 8411-like chips. at last we add
> support for rtl8402 chip.
> 
> Micky Ching (2):
>   mfd: rtsx: add set pull control macro and simplify rtl8411
>   mfd: rtsx: add support for card reader rtl8402
> 
>  drivers/mfd/rtl8411.c  |   95 ++++++++++++++++++++++++++----------------------
>  drivers/mfd/rtsx_pcr.c |    5 +++
>  drivers/mfd/rtsx_pcr.h |    9 +++++
>  3 files changed, 66 insertions(+), 43 deletions(-)
> 

Great.  Looks good to me.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

