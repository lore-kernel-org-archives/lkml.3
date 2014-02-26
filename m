Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaBZJC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:02:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:2387 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbaBZJCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 04:02:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,546,1389772800"; 
   d="scan'208";a="462464731"
Date: Wed, 26 Feb 2014 11:09:31 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Lan Tianyu <tianyu.lan@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        Alan Cox <alan.cox@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] gpio / ACPI: Rename acpi_gpio_evt_pin to
 acpi_gpio_event
Message-ID: <20140226090931.GV5018@intel.com>
References: <1393257611-18031-1-git-send-email-mika.westerberg@linux.intel.com>
 <1393257611-18031-4-git-send-email-mika.westerberg@linux.intel.com>
 <10661491.9ZT613bo8E@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10661491.9ZT613bo8E@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 03:23:51PM +0100, Rafael J. Wysocki wrote:
> On Monday, February 24, 2014 06:00:08 PM Mika Westerberg wrote:
> > In order to consolidate _Exx, _Lxx and _EVT to use the same structure we
> > make the structure name reflect that we are dealing with any event, not
> > just _EVT.
> 
> It's just a rename, right?  Then please say in the changelog that no functional
> changes should result from this.

OK, and I'm also going to rename field evt_handle to just handle in the
next version.
