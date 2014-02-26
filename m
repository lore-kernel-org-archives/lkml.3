Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbaBZJCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:02:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:17154 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbaBZJCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 04:02:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,546,1389772800"; 
   d="scan'208";a="488293031"
Date: Wed, 26 Feb 2014 11:10:01 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Lan Tianyu <tianyu.lan@intel.com>, Lv Zheng <lv.zheng@intel.com>,
        Alan Cox <alan.cox@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] gpio / ACPI: Embed events list directly into struct
 acpi_gpio_chip
Message-ID: <20140226091001.GW5018@intel.com>
References: <1393257611-18031-1-git-send-email-mika.westerberg@linux.intel.com>
 <1393257611-18031-5-git-send-email-mika.westerberg@linux.intel.com>
 <46469934.18k5deNECp@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46469934.18k5deNECp@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 03:26:12PM +0100, Rafael J. Wysocki wrote:
> On Monday, February 24, 2014 06:00:09 PM Mika Westerberg wrote:
> > It is not necessary to have events as a pointer to list in struct
> > acpi_gpio_chip. Instead we can embed the list_head directly to struct
> > acpi_gpio_chip itself. This makes event handling a bit simpler because now
> > we don't need to check whether the pointer is NULL or not.
> 
> It looks like I should have reviewed the whole series before commenting [2/6].
> 
> Well, my modified comment would be "Why don't you fold this one into [2/6]?", then.

I will in the next version, thanks.
