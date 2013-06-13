Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358Ab3FMCVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 22:21:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:25636 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757182Ab3FMCVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 22:21:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,855,1363158000"; 
   d="scan'208";a="328581184"
Message-ID: <1371090035.2135.7.camel@rzhang1-mobl4>
Subject: Re: [PATCH 0/7] thermal: ti-soc-thermal: fixes and DRA752 support
From: Zhang Rui <rui.zhang@intel.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 13 Jun 2013 10:20:35 +0800
In-Reply-To: <1369840066-20357-1-git-send-email-eduardo.valentin@ti.com>
References: <1369840066-20357-1-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-29 at 11:07 -0400, Eduardo Valentin wrote:
> Hello Rui,
> 
> Here is a patch set for your consideration on ti-soc-thermal driver.
> 

the whole patch set has been applied.

thanks,
rui
> This patch set is mix of:
> 
> (a) patches that were added to the staging tree post 3.10-rc1 but
> were not included after the move from staging to thermal. This is
> because your thermal tree is based of 3.10-rc1 and not staging/next
> or linux-next/master. Thus the first two patches make sure the driver
> under drivers/thermal/ti-soc-thermal has also the needed fixes.
> 
> (b) patches containing fixes found during the addition of DRA752
> chip support.
> 
> (c) patches adding the support to DRA752 chips.
> 
> Please consider these too for 3.11.
> 
> For those people interested in testing this patch set, it is based
> on thermal/next and can also be found here:
> https://git.gitorious.org/thermal-framework/thermal-framework.git thermal_work/ti-soc-thermal/fixes+dra752
> 
> All best,
> 
> Eduardo Valentin (7):
>   thermal: ti-soc-thermal: update DT reference for OMAP5430
>   thermal: ti-soc-thermal: remove external heat while extrapolating
>     hotspot
>   thermal: ti-soc-thermal: freeze FSM while computing trend
>   thermal: ti-soc-thermal: remove usage of IS_ERR_OR_NULL
>   thermal: ti-soc-thermal: add thermal data for DRA752 chips
>   thermal: ti-soc-thermal: add dra752 chip to device table
>   thermal: ti-soc-thermal: add DT example for DRA752 chip
> 
>  .../devicetree/bindings/thermal/ti_soc_thermal.txt |  13 +
>  drivers/staging/ti-soc-thermal/dra752-bandgap.h    | 280 ++++++++++++
>  .../staging/ti-soc-thermal/dra752-thermal-data.c   | 476 +++++++++++++++++++++
>  drivers/thermal/ti-soc-thermal/Kconfig             |  12 +
>  drivers/thermal/ti-soc-thermal/Makefile            |   1 +
>  drivers/thermal/ti-soc-thermal/ti-bandgap.c        |  29 +-
>  drivers/thermal/ti-soc-thermal/ti-bandgap.h        |   5 +
>  drivers/thermal/ti-soc-thermal/ti-thermal-common.c |  43 +-
>  drivers/thermal/ti-soc-thermal/ti-thermal.h        |   6 +
>  9 files changed, 842 insertions(+), 23 deletions(-)
>  create mode 100644 drivers/staging/ti-soc-thermal/dra752-bandgap.h
>  create mode 100644 drivers/staging/ti-soc-thermal/dra752-thermal-data.c
> 


