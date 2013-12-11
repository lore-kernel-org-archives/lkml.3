Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab3LKOJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 09:09:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:45486 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133Ab3LKOJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 09:09:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,872,1378882800"; 
   d="scan'208";a="450548900"
Date: Wed, 11 Dec 2013 16:16:07 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] gpiolib: return -ENOENT if no GPIO mapping exists
Message-ID: <20131211141607.GJ2281@intel.com>
References: <1386729148-16262-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386729148-16262-1-git-send-email-acourbot@nvidia.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 11:32:28AM +0900, Alexandre Courbot wrote:
> Some devices drivers make use of optional GPIO parameters. For such
> drivers, it is important to discriminate between the case where no
> GPIO mapping has been defined for the function they are requesting, and
> the case where a mapping exists but an error occured while resolving it
> or when acquiring the GPIO.
> 
> This patch changes the family of gpiod_get() functions such that they
> will return -ENOENT if and only if no GPIO mapping is defined for the
> requested function. Other error codes are used when an actual error
> occured during the GPIO resolution.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
