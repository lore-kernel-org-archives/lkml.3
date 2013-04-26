Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867Ab3DZPGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 11:06:52 -0400
Received: from mga11.intel.com ([192.55.52.93]:3429 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab3DZPGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 11:06:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,559,1363158000"; 
   d="scan'208";a="328104019"
Message-ID: <1366988945.3603.46.camel@sauron.fi.intel.com>
Subject: Re: eGalax touchscreen regression
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Arnd Bergmann <arnd@arndb.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hui Wang <jason77.wang@gmail.com>,
        Zhang Jiejing <jiejing.zhang@freescale.com>,
        linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hofemeier, Ulf" <ulf.hofemeier@intel.com>
Date: Fri, 26 Apr 2013 18:09:05 +0300
In-Reply-To: <3076410.nE1Nu6ITeM@wuerfel>
References: <1366708088.9823.16.camel@sauron.fi.intel.com>
	 <20130423154007.GB4104@core.coreip.homeip.net>
	 <1366794193.21369.11.camel@sauron.fi.intel.com>
	 <3076410.nE1Nu6ITeM@wuerfel>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-26 at 16:59 +0200, Arnd Bergmann wrote:
> On Wednesday 24 April 2013 12:03:13 Artem Bityutskiy wrote:
> > On Tue, 2013-04-23 at 08:40 -0700, Dmitry Torokhov wrote:
> > > > the eGalax driver now requires OF. For us this is a regression because
> > > > we do not have OF: https://bugs.tizen.org/jira/browse/TIVI-740
> > > 
> > > I see. In this case we need to come up with a platform data to pass
> > > wakeup gpio in case platform does not support OF. irq_to_gpio() is not
> > > supported on many platforms, causing compilation errors.
> > > 
> > > Is the platform that you are trying to use the touchscreen upstream?
> > 
> > OK, so this is about just a monitor with a touchscreen (Giantec high-res
> > capacitive 11.6” LCD monitor). The touchscreen is connected to a
> > commodity hardware via USB.
> > 
> > So yes, the platform _is_ upstream  Namely, we use just a SandyBridge
> > PC.
> 
> So you use a usb-to-i2c interface?

I do not think so. The problem is that I do not have the HW, so I was
making guesses, and it looks like this driver has nothing to do with the
regression we've got. Sorry for the noise. We'll investigate this more
carefully internally.

-- 
Best Regards,
Artem Bityutskiy

