Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab3GOS3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:29:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:14870 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105Ab3GOS3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:29:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,670,1367996400"; 
   d="scan'208";a="268604145"
Date: Mon, 15 Jul 2013 21:34:38 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] pinctrl-baytrail: miscellaneous minor fixes
Message-ID: <20130715183438.GT4898@intel.com>
References: <1373457340-16666-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1373883870.24799.244.camel@smile>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373883870.24799.244.camel@smile>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 01:24:30PM +0300, Andy Shevchenko wrote:
> On Wed, 2013-07-10 at 14:55 +0300, Andy Shevchenko wrote: 
> > This is a set of small minor fixes against pinctrl-baytrail driver.
> 
> Linus, Mika, anyone do you have any comment on the series?

Well, looks good to me but I don't know the HW details. Anyway, I reviewed
the code so:

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
