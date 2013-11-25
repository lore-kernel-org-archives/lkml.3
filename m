Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab3KYIl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:41:56 -0500
Received: from mga11.intel.com ([192.55.52.93]:1115 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958Ab3KYIlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:41:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,766,1378882800"; 
   d="scan'208";a="439142371"
Date: Mon, 25 Nov 2013 10:41:27 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/7] net: rfkill: gpio: remove gpio conversion support
Message-ID: <20131125084127.GB21001@xps8300>
References: <1385122474-14926-1-git-send-email-mika.westerberg@linux.intel.com>
 <1385122474-14926-4-git-send-email-mika.westerberg@linux.intel.com>
 <CAAVeFuKm=AHf4Az+ZZXwWLtft2_zmCqy2Wscw25cWNCbn2T+dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAVeFuKm=AHf4Az+ZZXwWLtft2_zmCqy2Wscw25cWNCbn2T+dQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 23, 2013 at 05:59:30PM +0900, Alexandre Courbot wrote:
> Wouldn't it be possible (and simpler) to move patch 2 of your series
> to first position, and then to merge patch 1 and 3 together in second
> position? It seems to me that you are basically undoing much of the
> work of your first patch here (notably by removing
> rfkill_gpio_convert_to_desc() which ends up having a very short life)
> and that this could be avoided if you defined the platform lookup
> tables first.
> 
> Doing so would avoid prevent you from using gpio_to_desc() which you
> should never ever use anyway. :P

Adding the lookup table in first patch and then changing the driver in
the second creates a point to the history where this driver stops
working on this platform, which is something I'm not willing to do.

But, we can make one patch out of all three if everybody is OK with
that.

-- 
heikki
