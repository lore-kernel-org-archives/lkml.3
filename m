Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbaGWG4P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 02:56:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:2578 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755628AbaGWG4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 02:56:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,715,1400050800"; 
   d="scan'208";a="574051834"
Date: Wed, 23 Jul 2014 09:56:05 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v3] gpiolib: Export gpiochip_request_own_desc and
 gpiochip_free_own_desc
Message-ID: <20140723065605.GC1857@lahna.fi.intel.com>
References: <1406041261-5716-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406041261-5716-1-git-send-email-linux@roeck-us.net>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 08:01:01AM -0700, Guenter Roeck wrote:
> Both functions were introduced to let gpio drivers request their own
> gpio pins. Without exporting the functions, this can however only be
> used by gpio drivers built into the kernel.
> 
> Secondary impact is that the functions can not currently be used by
> platform initialization code associated with the gpio-pca953x driver.
> This code permits auto-export of gpio pins through platform data, but
> if this functionality is used, the module can no longer be unloaded due
> to the problem solved with the introduction of gpiochip_request_own_desc
> and gpiochip_free_own_desc.
> 
> Export both function so they can be used from modules and from
> platform initialization code.
> 
> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>

Looks good to me, thanks.

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
