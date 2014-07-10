Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbaGJGnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 02:43:14 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:11199 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750725AbaGJGnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 02:43:12 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18TtGDvy526Z90ObYu3XLPj
Date: Wed, 9 Jul 2014 23:43:05 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, mika.westerberg@linux.intel.com
Subject: Re: [RFC PATCH 3/4] tty: serial: 8250 core: add runtime pm
Message-ID: <20140710064305.GG28884@atomide.com>
References: <1404491651-1388-1-git-send-email-bigeasy@linutronix.de>
 <1404491651-1388-3-git-send-email-bigeasy@linutronix.de>
 <20140707142056.46f61cf9@alan.etchedpixels.co.uk>
 <20140709111705.GR28884@atomide.com>
 <53BD291D.3040307@linutronix.de>
 <20140709114837.GU28884@atomide.com>
 <53BD38D3.2000204@linutronix.de>
 <20140709151242.GY28884@atomide.com>
 <53BD6EB3.4020305@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BD6EB3.4020305@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140709 09:35]:
> On 07/09/2014 05:12 PM, Tony Lindgren wrote:
> > And also please note that for runtime PM the wake-up events need
> > to be always enabled, so the device_may_wakeup() checks should
> > be only implemented for suspend and resume. I think I got that
> > corrected for most part in omap-serial.c recently, but knowing
> > that might reduce the confusion a bit :)
> 
> Ehm. I also added it to omap_8250_pm() as it is done in omap-serial (in
> serial_omap_pm()). Should I get rid of it in the latter?

Yes, I commented on that patch also.

Regards,

Tony
