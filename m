Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbaBJJ7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 04:59:12 -0500
Received: from mga14.intel.com ([143.182.124.37]:58316 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307AbaBJJ7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 04:59:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,816,1384329600"; 
   d="scan'208";a="472672340"
Date: Mon, 10 Feb 2014 12:06:13 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] gpiolib: ACPI: remove gpio_to_desc() usage
Message-ID: <20140210100613.GV18029@intel.com>
References: <1391935435-29002-1-git-send-email-acourbot@nvidia.com>
 <1391935435-29002-2-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391935435-29002-2-git-send-email-acourbot@nvidia.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09, 2014 at 05:43:55PM +0900, Alexandre Courbot wrote:
> gpio_to_desc() must die. Replace one of its usage by the
> newly-introduced gpiochip_get_desc() function.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
> Mika, can we have your review on this?

Sure, looks good.

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
