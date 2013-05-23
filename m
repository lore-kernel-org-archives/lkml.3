Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab3EWHkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 03:40:11 -0400
Received: from mga02.intel.com ([134.134.136.20]:29303 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab3EWHkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 03:40:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,726,1363158000"; 
   d="scan'208";a="341855459"
Date: Thu, 23 May 2013 10:44:16 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio-lynxpoint: remove unnecessary platform_set_drvdata()
Message-ID: <20130523074416.GD11878@intel.com>
References: <1369218646-29556-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369218646-29556-1-git-send-email-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 01:30:46PM +0300, Andy Shevchenko wrote:
> Since 0998d06310 "device-core: Ensure drvdata = NULL when no driver is bound",
> this is done by driver core after device_release or on probe failure. Thus we
> can remove all platform_set_drvdata(pdev, NULL) in drivers.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
