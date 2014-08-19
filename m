Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145AbaHSJen (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 05:34:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:46390 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbaHSJel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 05:34:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,893,1400050800"; 
   d="scan'208";a="578656725"
Date: Tue, 19 Aug 2014 12:34:12 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: Re: [PATCH 2/2] gpio: change gpiochip_request_own_desc() prototype
Message-ID: <20140819093412.GK1660@lahna.fi.intel.com>
References: <1408380657-6718-1-git-send-email-acourbot@nvidia.com>
 <1408380657-6718-3-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408380657-6718-3-git-send-email-acourbot@nvidia.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 09:50:57AM -0700, Alexandre Courbot wrote:
> The current prototype of gpiochip_request_own_desc() requires to obtain
> a pointer to a descriptor. This is in contradiction to all other GPIO
> request schemes, and imposes an extra step of obtaining a descriptor to
> drivers. Most drivers actually cannot even perform that step since the
> function that does it (gpichip_get_desc()) is gpiolib-private.
> 
> Change gpiochip_request_own_desc() to return a descriptor from a
> (chip, hwnum) tuple and update users of this function (currently
> gpiolib-acpi only).
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Tested on Asus T100TA and everything still seems to work so,

Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
