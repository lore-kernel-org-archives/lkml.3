Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab3BATQ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 14:16:29 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:54863 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754766Ab3BATQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 14:16:28 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18TfI3yAFxNUTCXRgZKjmAZ
Date: Fri, 1 Feb 2013 11:16:24 -0800
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, rob.herring@calxeda.com,
        rob@landley.net, b-cousson@ti.com, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org
Subject: Re: [PATCH v2 2/4] ARM: OMAP: devices: create device for usb part
 of control module
Message-ID: <20130201191624.GR22517@atomide.com>
References: <1358777308-2409-1-git-send-email-kishon@ti.com>
 <1358777308-2409-3-git-send-email-kishon@ti.com>
 <20130123112422.GF29258@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130123112422.GF29258@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [130123 03:27]:
> Hi,
> 
> On Mon, Jan 21, 2013 at 07:38:26PM +0530, Kishon Vijay Abraham I wrote:
> > A seperate driver has been added to handle the usb part of control
> > module. A device for the above driver is created here, using the register
> > address information to be used by the driver for powering on the PHY and
> > for writing to the mailbox.
> > 
> > Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> 
> Tony ? Without this we won't have the control module driver.

Looks OK to me, but please see my other reply regarding on
you setting up some immutable branches to avoid pointless
merge conflicts.

Regards,

Tony
