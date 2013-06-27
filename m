Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab3F0Uep (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 16:34:45 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:52813 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754292Ab3F0Uen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 16:34:43 -0400
Date: Thu, 27 Jun 2013 22:34:36 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Kevin Strasser <kevin.strasser@linux.intel.com>,
        linux-kernel@vger.kernel.org, Kevin Strasser <strassek@engr.orst.edu>,
        Darren Hart <dvhart@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Michael Brunner <mibru@gmx.de>, Chris Healy <chealy@imsco-us.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dirk Hohndel <Dirk.Hohndel@intel.com>,
        Wolfram Sang <wsa@the-dreams.de>, Ben Dooks <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>, linux-i2c@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v3 0/4] Kontron PLD drivers
Message-ID: <20130627203436.GB30950@spo001.leaseweb.com>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com> <1372046406-3127-1-git-send-email-kevin.strasser@linux.intel.com> <20130624120650.GC30838@zurbaran>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624120650.GC30838@zurbaran>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

> > Changes since v2:
> > -Change Michael's "Signed-off-by" to "Originally-From" in all patches
> > -Add "From: Guenter Roeck <linux@roeck-us.net>" to gpio patch
> > 
> > Guenter Roeck (1):
> >   gpio: Kontron PLD gpio driver
> > 
> > Kevin Strasser (3):
> >   mfd: Kontron PLD mfd driver
> >   i2c: Kontron PLD i2c bus driver
> >   watchdog: Kontron PLD watchdog timer driver
> I just applied (after a warning fix) and pushed the MFD driver, thanks.
> 
> I am happy to take the sub devices driver as well, although the
> respective maintainers can safely carry them as they all have a Kconfig
> dependency on MFD_KEMPLD. So it's up to them.
> If I have to take them, I'd need Wolfram's ACK for the i2c one and Wim's
> for the watchdog one. Linus already ACKed the GPIO one.

Acked-by: Wim Van Sebroeck <wim@iguana.be>

I'm OK that itgoes via the MFD tree.

Kind regards,
Wim.

