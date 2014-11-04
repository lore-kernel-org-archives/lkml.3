Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbaKDQHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:07:49 -0500
Received: from mga11.intel.com ([192.55.52.93]:27680 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255AbaKDQHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:07:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="411236371"
Date: Tue, 4 Nov 2014 18:07:35 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Grant Likely <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <darren.hart@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>
Subject: Re: [PATCH v6 04/12] misc: at25: Make use of device property API
Message-ID: <20141104160735.GO1618@lahna.fi.intel.com>
References: <13750506.S2yVlRRDa2@vostro.rjw.lan>
 <20141104143801.GM1618@lahna.fi.intel.com>
 <CACxGe6u5ppSjHc-Wa7K_NWQ9YEZ_V3ys9fdsECss_bPabUTN+g@mail.gmail.com>
 <4645043.WOkgNMSUuO@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4645043.WOkgNMSUuO@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 05:19:02PM +0100, Rafael J. Wysocki wrote:
> > > I think np->name is "at25" in this case? The binding file
> > > Documentation/devicetree/bindings/misc/at25.txt also has the same name.
> > >
> > > Are you OK, if we add something like below to the changelog?
> > >
> > >  In addition we hard-code the name of the chip to be "at25" for the
> > >  reason that there is no common mechanism to fetch name of the firmware
> > >  node. The only existing user (arch/arm/boot/dts/phy3250.dts) uses the
> > >  same name so it should continue to work.
> > 
> > Yes. If somebody complains, then we can reinstate the previous
> > behaviour, but assume it isn't necessary for now.
> 
> OK, done in my tree. 

Thanks Rafael!
