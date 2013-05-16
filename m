Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab3EPWSL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 18:18:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:62180 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742Ab3EPWSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 18:18:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,686,1363158000"; 
   d="scan'208";a="338563842"
Date: Fri, 17 May 2013 00:18:02 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: rogerable@realtek.com
Cc: cjb@laptop.org, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, gregkh@linuxfoundation.org,
        wei_wang@realsil.com.cn
Subject: Re: [PATCH] mfd:rtsx: Support RTL8411B
Message-ID: <20130516221802.GX22822@zurbaran>
References: <1366379562-23429-1-git-send-email-rogerable@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366379562-23429-1-git-send-email-rogerable@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roger,

On Fri, Apr 19, 2013 at 09:52:42PM +0800, rogerable@realtek.com wrote:
> From: Roger Tseng <rogerable@realtek.com>
> 
> Adding support of model RTL8411B. Since the model is similar to RTL8411,
> differences are implemented in rtl8411.c.
> 
> Signed-off-by: Roger Tseng <rogerable@realtek.com>
> ---
>  drivers/mfd/rtl8411.c        | 132 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/mfd/rtsx_pcr.c       |   5 ++
>  drivers/mfd/rtsx_pcr.h       |   1 +
>  include/linux/mfd/rtsx_pci.h |   1 +
>  4 files changed, 139 insertions(+)
Patch applied to mfd-next, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
