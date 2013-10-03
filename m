Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab3JCEDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:03:30 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:27449 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab3JCED2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:03:28 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19j2uIpf+MhAZd560rjbHck
Date: Wed, 2 Oct 2013 21:03:12 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: balbi@ti.com, bcousson@baylibre.com, p.zabel@pengutronix.de,
        broonie@kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 03/10] ARM: OMAP2+: omap-usb-host: Get rid of
 platform_data from struct usbhs_phy_data
Message-ID: <20131003040311.GH8949@atomide.com>
References: <1380012836-29900-1-git-send-email-rogerq@ti.com>
 <1380012836-29900-4-git-send-email-rogerq@ti.com>
 <524BF332.4080303@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524BF332.4080303@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [131002 03:27]:
> Hi Tony,
> 
> On 09/24/2013 11:53 AM, Roger Quadros wrote:
> > The platform data bits can be inferred from the other members of
> > struct usbhs_phy_data. So get rid of the platform_data member.
> > 
> > Build the platform data for the PHY device in usbhs_init_phys() instead.
> > 
> > Signed-off-by: Roger Quadros <rogerq@ti.com>
> 
> Could you please Ack this if OK?

This should be OK for you guys to queue. You should coordinate
the .dts changes with Benoit though. It might be best to have
this branch as an immutable branch against -rc3 that we can
all merge in as needed.

For this patch:

Acked-by: Tony Lindgren <tony@atomide.com>
