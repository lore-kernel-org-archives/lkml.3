Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab3JCED6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:03:58 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:28044 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab3JCED4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:03:56 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX188nkQqqqrcNf3bNlAhzZH8
Date: Wed, 2 Oct 2013 21:03:47 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: balbi@ti.com, bcousson@baylibre.com, p.zabel@pengutronix.de,
        broonie@kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 04/10] ARM: OMAP2+: usb-host: Adapt to USB phy-nop
 RESET line changes
Message-ID: <20131003040346.GI8949@atomide.com>
References: <1380012836-29900-1-git-send-email-rogerq@ti.com>
 <1380012836-29900-5-git-send-email-rogerq@ti.com>
 <524BF354.3000502@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524BF354.3000502@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [131002 03:28]:
> Hi Tony,
> 
> On 09/24/2013 11:53 AM, Roger Quadros wrote:
> > The USB phy-nop nop driver expects the RESET line information
> > to be sent as a GPIO number via platform data. Adapt to that.
> > 
> > Signed-off-by: Roger Quadros <rogerq@ti.com>
> 
> Need your Ack on this one as well.

Acked-by: Tony Lindgren <tony@atomide.com>
