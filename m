Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330AbaJ3KWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:22:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:29164 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759124AbaJ3KWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:22:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="408412253"
Date: Thu, 30 Oct 2014 12:22:34 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Alexandre Courbot <gnurou@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Darren Hart <dvhart@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] ACPI / GPIO: Driver GPIO mappings for ACPI GPIOs
Message-ID: <20141030102234.GP1304@lahna.fi.intel.com>
References: <CAAVeFuLW6fucvDxQvY5DDfnhPrgYM+1pi7WoHfBQa_BgYnc_Cw@mail.gmail.com>
 <3242497.urQmuvpeyA@vostro.rjw.lan>
 <CAAVeFuKStrzzwW7s37y7-a8y+j1gD-EzAYfc1h2KTo8uyd+dSA@mail.gmail.com>
 <13007048.sH0aJYjMUX@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13007048.sH0aJYjMUX@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 01:45:09AM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: ACPI / GPIO: Document ACPI GPIO mappings API
> 
> Document the previously introduced method that can be used by device
> drivers to provide the GPIO subsystem with mappings between GPIO names
> (connection IDs) and GpioIo()/GpioInt() resources in _CRS.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Looks really good to me,

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
