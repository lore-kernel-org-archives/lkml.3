Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759175Ab3K1Q6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 11:58:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:17338 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758720Ab3K1Q6V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 11:58:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,792,1378882800"; 
   d="scan'208";a="441676880"
Date: Thu, 28 Nov 2013 19:04:57 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/6] gpio / ACPI: convert users to gpiod_* and drop
 acpi_gpio.h
Message-ID: <20131128170457.GD2281@intel.com>
References: <1385460350-17543-1-git-send-email-mika.westerberg@linux.intel.com>
 <CACRpkdbJsQOjJ5QLVL9WutN9c04-AfRKe-hCYZ0fxDKsfCZS6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbJsQOjJ5QLVL9WutN9c04-AfRKe-hCYZ0fxDKsfCZS6Q@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 28, 2013 at 03:36:40PM +0100, Linus Walleij wrote:
> On Tue, Nov 26, 2013 at 11:05 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> 
> > Since the patches in the series depend on each other I would propose this
> > to be merged via GPIO tree.
> 
> Sure! Can you hunt the net/mmc/Tegra subsystem maintainers
> for ACKs please?

I think Stephen already tested the tegra parts and his Tested-by is added
to the patches.

Chris,

Do you have any comments on the series? Could you give your ACK for the mmc
part if you are OK with that?

Thanks.
