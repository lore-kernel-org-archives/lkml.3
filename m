Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbaEPMDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:03:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:20026 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757194AbaEPMDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:03:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1067,1389772800"; 
   d="scan'208";a="433023531"
Date: Fri, 16 May 2014 15:03:37 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linus Walleij <linus.walleij@linaro.org>, Jin Yao <yao.jin@intel.com>,
        Aubrey Li <aubrey.li@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] pinctrl: baytrail: Add back Baytrail-T ACPI ID
Message-ID: <20140516120337.GE2067@lahna.fi.intel.com>
References: <1400167727-20233-1-git-send-email-mika.westerberg@linux.intel.com>
 <1593450.1tg6AZy8cc@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1593450.1tg6AZy8cc@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 02:10:47PM +0200, Rafael J. Wysocki wrote:
> On Thursday, May 15, 2014 06:28:46 PM Mika Westerberg wrote:
> > From: Jin Yao <yao.jin@intel.com>
> > 
> > Now that the x86 dynamic IRQ allocation problem has been resolved with
> > commmit 62a08ae2a576 (genirq: x86: Ensure that dynamic irq allocation does
> > not conflict), we can add back Baytrail-T ACPI ID to the pinctrl driver.
> > 
> > This makes the driver to work on Asus T100 where it is needed for several
> > things like ACPI GPIO events and SD card detection.
> > 
> > References: https://bugzilla.kernel.org/show_bug.cgi?id=68291
> > Signed-off-by: Jin Yao <yao.jin@intel.com>
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Thanks!

> And I think this is pinctrl material really.

Indeed, only one change touches drivers/acpi/ but wanted to keep you in
the loop. I'm hoping that Linus W. takes these.
