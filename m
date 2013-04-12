Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab3DLGxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 02:53:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:14747 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752693Ab3DLGxA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 02:53:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,461,1363158000"; 
   d="scan'208";a="317061747"
Date: Fri, 12 Apr 2013 09:57:11 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] gpiolib-acpi: introduce acpi_get_gpio_by_index() helper
Message-ID: <20130412065710.GM1283@intel.com>
References: <1364986614-15711-1-git-send-email-mika.westerberg@linux.intel.com>
 <15166969.9Sfs2U7qQb@vostro.rjw.lan>
 <20130411072912.GE1283@intel.com>
 <CACRpkdYiNOLVAgZVhZG3OaJw5ZZ4OM8RPafCxPPfMWo2gVM=dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdYiNOLVAgZVhZG3OaJw5ZZ4OM8RPafCxPPfMWo2gVM=dg@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 12:35:05AM +0200, Linus Walleij wrote:
> On Thu, Apr 11, 2013 at 9:29 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> 
> > Grant and Linus W,
> >
> > Do you have any comments on this patch? Could it still be merged for 3.10?
> 
> No and yes.
> 
> Applied and pushed for linux-next now.

Thanks!

> Sorry for taking so long, I was confused by the discussion.

np. We probably need to add another ACPI GPIO helper function to get all
the GPIOs but I guess we can do that once a need emerges. For a single GPIO
(like the patch here does) we know already from internal discussion that it
will be needed.

> I had to use some fuzzing to apply the patch, please check the
> result in linux-next.

Looks good to me.
