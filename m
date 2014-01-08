Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbaAHM10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 07:27:26 -0500
Received: from mga02.intel.com ([134.134.136.20]:16911 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755441AbaAHM1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 07:27:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,624,1384329600"; 
   d="scan'208";a="463463175"
Date: Wed, 8 Jan 2014 14:34:24 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/4] mmc: sdhci-acpi: convert to use GPIO descriptor
 API
Message-ID: <20140108123424.GR2494@intel.com>
References: <1389177657-29266-1-git-send-email-mika.westerberg@linux.intel.com>
 <1389177657-29266-3-git-send-email-mika.westerberg@linux.intel.com>
 <CACRpkdYhynQ4ooHcZyc-nrgVK9gbvtsYR6ZVv1u0sfBVEaK93A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYhynQ4ooHcZyc-nrgVK9gbvtsYR6ZVv1u0sfBVEaK93A@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 12:54:13PM +0100, Linus Walleij wrote:
> On Wed, Jan 8, 2014 at 11:40 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> 
> > The new descriptor based GPIO interface is now the recommended and safer
> > way of using GPIOs from device drivers. Convert the ACPI SDHCI driver to
> > use that interface.
> >
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Acked-by: Adrian Hunter <adrian.hunter@intel.com>
> > Acked-by: Alexandre Courbot <acourbot@nvidia.com>
> 
> I've tentatively applied this to the GPIO tree now, as it was acked by
> Adrian who is a long time MMC subsystem contributor and we need
> it to proceed with the rest of the refactorings.

Thanks!
