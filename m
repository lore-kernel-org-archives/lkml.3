Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab3BCWcs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 17:32:48 -0500
Received: from mga14.intel.com ([143.182.124.37]:59847 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab3BCWco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 17:32:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,595,1355126400"; 
   d="scan'208";a="198290553"
Date: Sun, 3 Feb 2013 23:32:19 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Hongbo Zhang <hongbo.zhang@linaro.org>
Cc: linux@roeck-us.net, khali@linux-fr.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        linus.walleij@linaro.org, lee.jones@linaro.org
Subject: Re: [PATCH 1/2] ARM: ux500: rename ab8500 to abx500 for hwmon driver
Message-ID: <20130203223219.GZ8476@sortiz-mobl>
References: <1359541288-6657-1-git-send-email-hongbo.zhang@linaro.org>
 <1359541288-6657-2-git-send-email-hongbo.zhang@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359541288-6657-2-git-send-email-hongbo.zhang@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hongbo,

On Wed, Jan 30, 2013 at 06:21:27PM +0800, Hongbo Zhang wrote:
> We are using a generic abx500 hwmon layer, so rename specific ab8500 to generic
> abx500 for hwmon device and driver matching.
> 
> Signed-off-by: Hongbo Zhang <hongbo.zhang@linaro.org>
> ---
>  drivers/mfd/ab8500-core.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
Patch applied, after fixing the subject. Thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
