Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab3KYJD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:03:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:37276 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940Ab3KYJDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:03:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,766,1378882800"; 
   d="scan'208";a="441071336"
Date: Mon, 25 Nov 2013 11:02:19 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Alex Courbot <acourbot@nvidia.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/7] net: rfkill: gpio: remove gpio conversion support
Message-ID: <20131125090218.GC21001@xps8300>
References: <1385122474-14926-1-git-send-email-mika.westerberg@linux.intel.com>
 <1385122474-14926-4-git-send-email-mika.westerberg@linux.intel.com>
 <CAAVeFuKm=AHf4Az+ZZXwWLtft2_zmCqy2Wscw25cWNCbn2T+dQ@mail.gmail.com>
 <20131125084127.GB21001@xps8300>
 <52930EAA.7030208@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52930EAA.7030208@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 05:47:38PM +0900, Alex Courbot wrote:
> On 11/25/2013 05:41 PM, Heikki Krogerus wrote:
> >Adding the lookup table in first patch and then changing the driver in
> >the second creates a point to the history where this driver stops
> >working on this platform, which is something I'm not willing to do.
> 
> Does it? If you just add a lookup table and keep using the
> integer-based GPIO interface, then your lookup table will not be
> used by anyone and will basically be a no-op. Then you can switch to
> the GPIO descriptor interface and take advantage of the lookup
> table. Unless I missed something there should not be any point that
> breaks in the git history.
> 
> (to be clear: the first patch should *only* contain the lookup
> table, and the second be a merge of the current patches 1 and 3 of
> this series.)

OK, I agree. If I don't remove the old gpio numbers in in the first
patch, there is no problem. We can do this with the two patches.

Thanks,


-- 
heikki
