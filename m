Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab3AVD0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 22:26:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:21788 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269Ab3AVD0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 22:26:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,511,1355126400"; 
   d="scan'208";a="250508530"
Date: Tue, 22 Jan 2013 04:26:11 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 1/3] mfd: Fix compile errors and warnings when
 !CONFIG_AB8500_BM
Message-ID: <20130122032611.GK7409@sortiz-mobl>
References: <1357725965-27342-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1357725965-27342-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Wed, Jan 09, 2013 at 10:06:03AM +0000, Lee Jones wrote:
> drivers/mfd/ab8500-core.c:1015:21: error: ‘ab8500_bm_data’ undeclared here
> 
> include/linux/mfd/abx500/ab8500-bm.h:445:13: warning: ‘ab8500_fg_reinit’ defined but not used
> include/linux/mfd/abx500/ab8500-bm.h:448:13: warning: ‘ab8500_charger_usb_state_changed’ defined but not used
> include/linux/mfd/abx500/ab8500-bm.h:451:29: warning: ‘ab8500_btemp_get’ defined but not used
> include/linux/mfd/abx500/ab8500-bm.h:455:12: warning: ‘ab8500_btemp_get_batctrl_temp’ defined but not used
> include/linux/mfd/abx500/ab8500-bm.h:463:12: warning: ‘ab8500_fg_inst_curr_blocking’ defined but not used
> include/linux/mfd/abx500/ab8500-bm.h:442:12: warning: ‘ab8500_fg_inst_curr_done’ defined but not used
> include/linux/mfd/abx500/ab8500-bm.h:447:26: warning: ‘ab8500_fg_get’ defined but not used
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mfd/ab8500-core.c            |    1 +
>  include/linux/mfd/abx500.h           |    2 --
>  include/linux/mfd/abx500/ab8500-bm.h |   29 ++++-------------------------
>  3 files changed, 5 insertions(+), 27 deletions(-)
Applied to my for-linus branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
