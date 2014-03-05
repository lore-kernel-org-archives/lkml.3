Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027AbaCETkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 14:40:47 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:51842 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaCETkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 14:40:45 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/61I5K+N47eVO0CQXyJxVY
Date: Wed, 5 Mar 2014 11:40:36 -0800
From: Tony Lindgren <tony@atomide.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: bcousson@baylibre.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        george.cherian@ti.com, heikki.krogerus@linux.intel.com, rogerq@ti.com,
        balbi@ti.com, devicetree@vger.kernel.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net, linux@arm.linux.org.uk,
        gregkh@linuxfoundation.org, grant.likely@linaro.org,
        s.nawrocki@samsung.com, galak@codeaurora.org
Subject: Re: [PATCH v5 6/6] arm/dts: added dt properties to adapt to the new
 phy framwork
Message-ID: <20140305194036.GC7599@atomide.com>
References: <1393846695-14644-1-git-send-email-kishon@ti.com>
 <1393846695-14644-7-git-send-email-kishon@ti.com>
 <53171BC9.8050808@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53171BC9.8050808@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kishon Vijay Abraham I <kishon@ti.com> [140305 04:46]:
> Tony/Benoit,
> 
> On Monday 03 March 2014 05:08 PM, Kishon Vijay Abraham I wrote:
> >Added device tree bindings for dwc3, usb2 and usb3 PHYs. The documentation
> >of these can be found at Documentation/devicetree/bindings/phy/phy-bindings.txt
> >and Documentation/devicetree/bindings/phy/ti-phy.txt.
> 
> Can this patch be queued for 3.15 merge window?

Thanks applying this patch into omap-for-v3.15/dt.

Tony
