Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab3BATSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 14:18:14 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:58200 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753600Ab3BATSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 14:18:12 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18va54qvVWRSwzOaCMyMoLc
Date: Fri, 1 Feb 2013 11:18:10 -0800
From: Tony Lindgren <tony@atomide.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: balbi@ti.com, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        eballetbo@gmail.com, javier@dowhile0.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH v2 3/6] ARM: OMAP: USB: Add phy binding information
Message-ID: <20130201191810.GS22517@atomide.com>
References: <1359081206-5602-1-git-send-email-kishon@ti.com>
 <1359081206-5602-4-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359081206-5602-4-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kishon Vijay Abraham I <kishon@ti.com> [130124 18:36]:
> This is w.r.t the changes in PHY library to support adding and getting
> multiple PHYs of the same type. In the new design, the
> binding information between the PHY and the USB controller should be
> specified in the platform specific initialization code. So it's been
> done here for OMAP platforms.

This looks OK to me, but should be queued by Felipe in his
minimal USB platform_data changes branch that I can pull in too
to avoid pointless merge conflicts.

Regards,

Tony
