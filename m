Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbaJ0HuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 03:50:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:1865 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbaJ0HuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 03:50:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="406541627"
Date: Mon, 27 Oct 2014 09:50:04 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Arnd Bergmann <arnd@arndb.de>, Alexandre Courbot <gnurou@gmail.com>,
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
Subject: Re: GPIO bindings guidelines (Was: Re: [PATCH v5 10/12] gpio:
 Support for unified device properties interface)
Message-ID: <20141027075004.GW1484@lahna.fi.intel.com>
References: <CAAVeFuLW6fucvDxQvY5DDfnhPrgYM+1pi7WoHfBQa_BgYnc_Cw@mail.gmail.com>
 <1581499.2RkCnyfbq6@vostro.rjw.lan>
 <20141024073436.GN1484@lahna.fi.intel.com>
 <1971306.rIA5QAW7ve@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1971306.rIA5QAW7ve@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2014 at 12:00:33AM +0200, Rafael J. Wysocki wrote:
> I folded your fixes into my patch and I'm going to send the result, with a
> changelog, in a reply to this message.

Thanks!

> If everyone is happy with it, I'll add it to the device properties patch
> series as it depends on those.
> 
> I guess you can add a changelog to your rfkill changes and then we could
> add them to that series too if there are no objections.

OK, I'll do that today.
