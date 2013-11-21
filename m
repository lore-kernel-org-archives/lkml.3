Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab3KURRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 12:17:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:13812 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833Ab3KURRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 12:17:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,745,1378882800"; 
   d="scan'208";a="412521494"
Date: Thu, 21 Nov 2013 19:22:17 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alex Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] net: rfkill: gpio: convert to descriptor-based GPIO
 interface
Message-ID: <20131121172217.GE2281@intel.com>
References: <1385045153-25160-1-git-send-email-mika.westerberg@linux.intel.com>
 <1385045153-25160-2-git-send-email-mika.westerberg@linux.intel.com>
 <20131121152425.GA5557@xps8300>
 <528E3D5E.20907@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528E3D5E.20907@nvidia.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 12:05:34PM -0500, Rhyland Klein wrote:
> This seems like a reasonable patch, and likely a good way to go. I don't
> have a AC100 to test this with though, so I can't verify this
> personally. Also, would the paz00 patch become a dependency of this
> patchset? Mika, maybe you can therefore include a patch for paz00 in
> your patchset?

Sure I can, if everyone is OK with that.
