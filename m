Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab3GXTMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 15:12:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:28726 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579Ab3GXTMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 15:12:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,736,1367996400"; 
   d="scan'208";a="375830337"
Date: Thu, 25 Jul 2013 00:03:29 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Joel Fernandes <joelf@ti.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Dan Williams <djbw@fb.com>,
        Tony Lindgren <tony@atomide.com>, "Nori, Sekhar" <nsekhar@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Nayak, Rajendra" <rnayak@ti.com>,
        "Vutla, Lokesh" <lokeshvutla@ti.com>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
        Matt Porter <matt@ohporter.com>, Rob Herring <rob.herring@calxeda.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH] dma: edma: add device_slave_caps() support
Message-ID: <20130724183329.GH18642@intel.com>
References: <1374597804-3961-1-git-send-email-joelf@ti.com>
 <51EF8A52.90902@metafoo.de>
 <51EF8C2B.2030409@ti.com>
 <51EF8F4E.8080806@metafoo.de>
 <FB20353E-4890-4462-A671-3587A3841B4A@ti.com>
 <51EF92F2.3030405@metafoo.de>
 <51F0231C.7000401@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F0231C.7000401@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 01:55:24PM -0500, Joel Fernandes wrote:
> On 07/24/2013 03:40 AM, Lars-Peter Clausen wrote:
> > On 07/24/2013 10:28 AM, Fernandes, Joel wrote:
> >>>>>> Vinod, or Dan- If this patch looks ok, can you please merge in for
> >>>>>> -rc cycle? This patch is required to fix MMC support on AM33xx. This
> >>>>>> patch is blocking 3 other patches which fix various MMC things. Thanks!
Sorry I was travelling so not realy on top of email for last few days...

Now I am not sure we can send this to -rc.
If it were just this one, we could have pushed but it also depends on a new API
which is sitting in my -next. I am not super comfortable to send that to Linus
for the -rcs. Sure, he would scream at me!

Also another point worth considering is the approach Russell suggested, I havent
gotten a chance to dig deeper but if I understood it correctly then programming
the device_dma_parameters should be the right thing to do. Again I need to look
deeper and esp wrt edma

~Vinod
