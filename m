Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab3GOKYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 06:24:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:53832 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971Ab3GOKYj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 06:24:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,668,1367996400"; 
   d="scan'208";a="370359445"
Message-ID: <1373883870.24799.244.camel@smile>
Subject: Re: [PATCH 0/5] pinctrl-baytrail: miscellaneous minor fixes
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Date: Mon, 15 Jul 2013 13:24:30 +0300
In-Reply-To: <1373457340-16666-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1373457340-16666-1-git-send-email-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-10 at 14:55 +0300, Andy Shevchenko wrote: 
> This is a set of small minor fixes against pinctrl-baytrail driver.

Linus, Mika, anyone do you have any comment on the series?

> 
> Andy Shevchenko (5):
>   pinctrl-baytrail: fix indentations
>   pinctrl-baytrail: change lvl to level
>   pinctrl-baytrail: remove redundant ptr variable
>   pinctrl-baytrail: introduce to_byt_gpio() macro
>   pinctrl-baytrail: fix to avoid sparse warnings
> 
>  drivers/pinctrl/Kconfig            |  2 +-
>  drivers/pinctrl/pinctrl-baytrail.c | 37 +++++++++++++++++++++----------------
>  2 files changed, 22 insertions(+), 17 deletions(-)
> 

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
