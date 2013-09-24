Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab3IXP4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 11:56:52 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:51310 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753763Ab3IXP4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 11:56:50 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19wQcjPO5xNujavlLFjA6rW
Date: Tue, 24 Sep 2013 08:56:37 -0700
From: Tony Lindgren <tony@atomide.com>
To: Balaji T K <balajitk@ti.com>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, Pawel Moll <pawel.moll@arm.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Jon Hunter <jgchunter@gmail.com>, linux-gpio@vger.kernel.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, r.sricharan@ti.com, holler@ahsoftware.de
Subject: Re: [RFC v2] gpio/omap: auto-setup a GPIO when used as an IRQ
Message-ID: <20130924155637.GO2684@atomide.com>
References: <1380009480-4975-1-git-send-email-javier.martinez@collabora.co.uk>
 <20130924154048.GM2684@atomide.com>
 <5241B3B7.5070701@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5241B3B7.5070701@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Balaji T K <balajitk@ti.com> [130924 08:54]:
> On Tuesday 24 September 2013 09:10 PM, Tony Lindgren wrote:
> >
> >Also please mention the regression that this fixes. So far we know
> >that smsc911x for tobi and igep boards in mainline, and also the
> 
> >MMC card detect for omap4 boards.
> Hi Tony,
> 
> Card detect on omap4 board (sdp and panda) is not based on omap gpio,
> so I think this fix is not applicable for omap4.
> 
> Card detect line for SD card goes to power IC on OMAP4 panda and SDP.

Hmm OK is that the twl6030_mmc_card_detect_config() on PMIC?

Santosh, care to clarify what you mentioned to me earlier
regarding the MMC card detect regression?

Regards,

Tony
