Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075Ab3DDKJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 06:09:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:45444 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756635Ab3DDKJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 06:09:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,407,1363158000"; 
   d="scan'208";a="316788968"
Date: Thu, 4 Apr 2013 13:13:38 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH] gpiolib-acpi: introduce acpi_get_gpio_by_index() helper
Message-ID: <20130404101338.GK21804@intel.com>
References: <1364986614-15711-1-git-send-email-mika.westerberg@linux.intel.com>
 <CAN+gG=F4LMHMsOqVh+BikSLKBJ8V7ni-p4hKi7yRb4jjD7gv0w@mail.gmail.com>
 <20130404093820.GI21804@intel.com>
 <CAN+gG=F7T6ujLuNu2hfEKfrDwBCG9xM_e3P9Fan0Awj7EYmJyA@mail.gmail.com>
 <20130404095716.GJ21804@intel.com>
 <CAN+gG=Edb-iTLeafeDw+E33rJWthSM8Qr37yQJNOG9p45_rrbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=Edb-iTLeafeDw+E33rJWthSM8Qr37yQJNOG9p45_rrbw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 12:01:23PM +0200, Benjamin Tissoires wrote:
> > One option is to provide acpi_get_gpio_all() that returns all GPIOs and
> > their corresponding types. That should allow clients like i2c-hid to find
> > the right GPIO (I'm hoping that there will be only one GpioInt associated
> > with these devices).
> 
> That could do the trick.

Great.

> However, I won't be able to test it. I still don't have access to any
> ACPI 5 device with i2c-hid devices...

I have few such devices but none of them has GpioInt resources (they have
the interrupt line routed to ioapic), so I can't test the i2c-hid with
GpioInt either :-/
