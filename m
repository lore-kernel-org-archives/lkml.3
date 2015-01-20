Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbbATMdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 07:33:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:17647 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219AbbATMdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 07:33:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="442694420"
Message-ID: <1421757193.31903.60.camel@linux.intel.com>
Subject: Re: [PATCH v1 1/4] mfd: change a layout for the Intel related
 drivers
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Date: Tue, 20 Jan 2015 14:33:13 +0200
In-Reply-To: <1418313236-10764-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1418313236-10764-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1418313236-10764-2-git-send-email-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-11 at 17:53 +0200, Andy Shevchenko wrote:
> Instead of keeping everything in one folder with long prefixes let us to reoder
> files in the tree by moving them in the dedicated folder. Currently we have
> drivers for Intel MID platforms, LPC, and few more are coming.
> 
> This patch creates a new layout and moves intel_msic driver to it.
> 

[]

> @@ -1376,4 +1367,7 @@ config MFD_VEXPRESS_SYSREG
>  	  on the ARM Ltd. Versatile Express board.
>  
>  endmenu
> +
> +source "drivers/mfd/intel/Kconfig"
> +
>  endif

Mika reported that this change should go inside the menu-endmenu block.

-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

