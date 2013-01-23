Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab3AWRgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 12:36:33 -0500
Received: from mga09.intel.com ([134.134.136.24]:62657 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932074Ab3AWRgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 12:36:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,523,1355126400"; 
   d="scan'208";a="275722022"
Date: Wed, 23 Jan 2013 19:40:21 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mike Turquette <mturquette@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 2/3] clk: x86: add support for Lynxpoint LPSS clocks
Message-ID: <20130123174021.GK2239@intel.com>
References: <1358516761-20981-1-git-send-email-mika.westerberg@linux.intel.com>
 <1358516761-20981-3-git-send-email-mika.westerberg@linux.intel.com>
 <20130122184754.24671.16583@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130122184754.24671.16583@quantum>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 10:47:54AM -0800, Mike Turquette wrote:
> Quoting Mika Westerberg (2013-01-18 05:46:00)
> > Intel Lynxpoint Low Power Subsystem hosts peripherals like UART, I2C and
> > SPI controllers. For most of these there is a configuration register that
> > allows software to enable and disable the functional clock. Disabling the
> > clock while the peripheral is not used saves power.
> > 
> > In order to take advantage of this we add a new clock gate of type
> > lpss_gate that just re-uses the ordinary clk_gate but in addition is able
> > to enumerate the base address register of the device using ACPI.
> > 
> > We then create a clock tree that models the Lynxpoint LPSS clocks using
> > these gates and fixed clocks so that we can pass clock rate to the drivers
> > as well.
> > 
> > Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> 
> Nice to see another architecture using this framework.
> 
> Acked-by: Mike Turquette <mturquette@linaro.org>

Thanks!

How about x86 maintainers? Do you have any comments on the series?
