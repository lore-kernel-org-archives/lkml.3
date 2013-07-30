Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757930Ab3G3H44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 03:56:56 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:10628 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087Ab3G3H4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 03:56:54 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19tMTIxEDteSt62MsZtnOQ6
Date: Tue, 30 Jul 2013 00:56:51 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, george.cherian@ti.com,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/4] usb: phy: rename nop_usb_xceiv => usb_phy_gen_xceiv
Message-ID: <20130730075650.GI7656@atomide.com>
References: <1374869757-923-1-git-send-email-bigeasy@linutronix.de>
 <1374869757-923-2-git-send-email-bigeasy@linutronix.de>
 <20130729122022.GF24801@radagast>
 <20130730070814.GF7656@atomide.com>
 <51F76C90.90207@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F76C90.90207@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <bigeasy@linutronix.de> [130730 00:41]:
> On 07/30/2013 09:08 AM, Tony Lindgren wrote:
> > Looking at this patch there's a pretty high probability of introducing
> > pointless merge conflicts.
> > 
> > How about do the platform data related changes as a separate follow-up
> > series? You can typically do this by keeping the old features around,
> > then doing a separate series to rename or remove the users later on.
> > This will remove the dependency between platform data and the driver
> > changes.
> 
> I can do this. This will work of for the driver name but not for the
> name the platform_data struct. To address this part you could create a
> separate branch on top of -rc3 or so which contains only this change(s)
> and Felipe and you merge this branch so there won't be any conflicts.

A separate minimal branch against -rc3 sounds good to me.

Regards,

Tony
