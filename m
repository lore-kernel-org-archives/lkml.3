Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242Ab3AQRAL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:00:11 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:12523 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752472Ab3AQRAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:00:09 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+XwiDotDb9XKa0y1zOj0yR
Date: Thu, 17 Jan 2013 08:59:44 -0800
From: Tony Lindgren <tony@atomide.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Roger Quadros <rogerq@ti.com>, balbi@ti.com, sameo@linux.intel.com,
        kishon@ti.com, sshtylyov@mvista.com, bjorn@mork.no,
        linux@arm.linux.org.uk, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 01/22] mfd: omap-usb-host: Consolidate OMAP USB-HS
 platform data
Message-ID: <20130117165943.GI14149@atomide.com>
References: <1358422231-24736-2-git-send-email-rogerq@ti.com>
 <Pine.LNX.4.44L0.1301171016090.1339-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1301171016090.1339-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Stern <stern@rowland.harvard.edu> [130117 07:19]:
> On Thu, 17 Jan 2013, Roger Quadros wrote:
> 
> > Let's have a single platform data structure for the OMAP's High-Speed
> > USB host subsystem instead of having 3 separate ones i.e. one for
> > board data, one for USB Host (UHH) module and one for USB-TLL module.
> > 
> > This makes the code much simpler and avoids creating multiple copies of
> > platform data.
> > 
> > CC: Alan Stern <stern@rowland.harvard.edu>
> > 
> > Signed-off-by: Roger Quadros <rogerq@ti.com>
> 
> For the ehci-omap.c part:
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

If Samuel acks this patch, I can apply just this patch alone on v3.8-rc3
into an immutable branch omap-for-v3.9/board-usb so we all merge it in
as needed.

Regards,

Tony
