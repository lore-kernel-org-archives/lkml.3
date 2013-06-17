Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab3FQXIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:08:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:37712 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963Ab3FQXIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:08:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,884,1363158000"; 
   d="scan'208";a="355016406"
Date: Tue, 18 Jun 2013 01:07:56 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Chao Xie <chao.xie@marvell.com>
Cc: linux-kernel@vger.kernel.org, yizhang@marvell.com
Subject: Re: [PATCH V2 0/9] mfd: 88pm80x: bug fixes and enhancement
Message-ID: <20130617230756.GU7998@zurbaran>
References: <1371187313-5776-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371187313-5776-1-git-send-email-chao.xie@marvell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

On Fri, Jun 14, 2013 at 01:21:44AM -0400, Chao Xie wrote:
> The patch set fixes some bugs in the 88pm800/88pm805 driver, and it add
> regulator device into 88pm800.
> 
> The patches are tested based on Marvell pxa988 platform.
> 
> V2->V1:
>   add more fixes patches.
>   Below patches are same almost same as V1
>      mfd: 88pm800: fix NULL pointer errorm
>      mfd: 88pm800/88pm805: remove "IRQF_TRIGGER_FALLING" flag
>   Other patches are new.
> 
> Chao Xie (7):
>   mfd: 88pm80x: fix driver name for 88pm800 and 88pm805
>   mfd: 88pm800: fix for mask_invert
>   mfd: 88pm800: remove the power and gpadc page addr from platform data
>   mfd: 88pm800: fixes error handling for sub pages probe/remove
>   mfd: 88pm80x: Changes chip id definition and detection
>   mfd: 88pm800: enhance sub devices initialization
>   mfd: 88pm800: add regulator sub device
> 
> Yi Zhang (2):
>   mfd: 88pm800: fix NULL pointer error
>   mfd: 88pm800/88pm805: remove "IRQF_TRIGGER_FALLING" flag
> 
>  drivers/mfd/88pm800.c       |  237 +++++++++++++++++++++++++------------------
>  drivers/mfd/88pm805.c       |   20 +---
>  drivers/mfd/88pm80x.c       |   47 +++++++--
>  include/linux/mfd/88pm80x.h |   17 ++--
>  4 files changed, 193 insertions(+), 128 deletions(-)
All 9 patches applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
