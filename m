Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660Ab3G3HIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 03:08:19 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:30567 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753194Ab3G3HIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 03:08:17 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19puPiME72wJDoeeCvlTH6K
Date: Tue, 30 Jul 2013 00:08:14 -0700
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        george.cherian@ti.com,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/4] usb: phy: rename nop_usb_xceiv => usb_phy_gen_xceiv
Message-ID: <20130730070814.GF7656@atomide.com>
References: <1374869757-923-1-git-send-email-bigeasy@linutronix.de>
 <1374869757-923-2-git-send-email-bigeasy@linutronix.de>
 <20130729122022.GF24801@radagast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729122022.GF24801@radagast>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [130729 05:27]:
> On Fri, Jul 26, 2013 at 10:15:54PM +0200, Sebastian Andrzej Siewior wrote:
> > The "nop" driver isn't a do-nothing-stub but supports a couple functions
> > like clock on/off or is able to use a voltage regulator. This patch
> > simply renames the driver to "generic" since it is easy possible to
> > extend it by a simple function istead of writing a complete driver.
> > 
> > Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> to me, this is great but I need Tony's Ack for it. Let's Cc Tony and
> linux-omap

Looking at this patch there's a pretty high probability of introducing
pointless merge conflicts.

How about do the platform data related changes as a separate follow-up
series? You can typically do this by keeping the old features around,
then doing a separate series to rename or remove the users later on.
This will remove the dependency between platform data and the driver
changes.

Regards,

Tony
