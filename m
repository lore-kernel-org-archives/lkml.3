Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760111Ab3DKHZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 03:25:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:38341 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab3DKHZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 03:25:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,454,1363158000"; 
   d="scan'208";a="316439032"
Date: Thu, 11 Apr 2013 10:29:12 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH] gpiolib-acpi: introduce acpi_get_gpio_by_index() helper
Message-ID: <20130411072912.GE1283@intel.com>
References: <1364986614-15711-1-git-send-email-mika.westerberg@linux.intel.com>
 <15166969.9Sfs2U7qQb@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15166969.9Sfs2U7qQb@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 01:04:26PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, April 03, 2013 01:56:54 PM Mika Westerberg wrote:
> > Instead of open-coding ACPI GPIO resource lookup in each driver, we provide
> > a helper function analogous to Device Tree version that allows drivers to
> > specify which GPIO resource they are interested (using an index to the GPIO
> > resources). The function then finds out the correct resource, translates
> > the ACPI GPIO number to the corresponding Linux GPIO number and returns
> > that.
> > 
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Grant and Linus W,

Do you have any comments on this patch? Could it still be merged for 3.10?

Thanks.
