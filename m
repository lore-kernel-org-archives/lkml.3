Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018Ab3DZJYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:24:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:56281 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756916Ab3DZJYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:24:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,557,1363158000"; 
   d="scan'208";a="293411478"
Date: Fri, 26 Apr 2013 11:23:11 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "M'boumba Cedric Madianga" <cedric.madianga@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        Michel JAOUEN <michel.jaouen@stericsson.com>
Subject: Re: [PATCH 20/21] MFD: ab8500: export ab8500_gpadc_sw_hw_convert
 properly
Message-ID: <20130426092311.GA5022@zurbaran>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
 <1366734653-488286-21-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366734653-488286-21-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Tue, Apr 23, 2013 at 06:30:52PM +0200, Arnd Bergmann wrote:
> Apparently the ab8500_gpadc_sw_hw_convert function got renamed
> from ab8500_gpadc_convert to ab8500_gpadc_sw_hw_convert in
> commit 734823462 "mfd: ab8500-gpadc: Add gpadc hw conversion",
> but the export for this function did not get changed at the
> same time, causing this allyesconfig error:
> 
> ERROR: "ab8500_gpadc_sw_hw_convert" [drivers/hwmon/ab8500.ko] undefined!
> 
> This patch fixes the export.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: M'boumba Cedric Madianga <cedric.madianga@stericsson.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Mattias WALLIN <mattias.wallin@stericsson.com>
> Cc: Michel JAOUEN <michel.jaouen@stericsson.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  drivers/mfd/ab8500-gpadc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
Applied to mfd-next, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
