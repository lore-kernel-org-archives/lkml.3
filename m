Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbaEPVPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 17:15:53 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:35610 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbaEPVPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 17:15:49 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19cd1x2LV/cjF+7dGUelfNL
Date: Fri, 16 May 2014 14:15:39 -0700
From: Tony Lindgren <tony@atomide.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Russell King <linux@arm.linux.org.uk>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: OMAP: replace checks for CONFIG_USB_GADGET_OMAP
Message-ID: <20140516211539.GH12881@atomide.com>
References: <1400187345.11786.28.camel@x220>
 <20140515231229.GA25523@saruman.home>
 <1400232974.20342.22.camel@x220>
 <1400234457.20342.25.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400234457.20342.25.camel@x220>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul Bolle <pebolle@tiscali.nl> [140516 03:01]:
> Commit 193ab2a60700 ("usb: gadget: allow multiple gadgets to be built")
> apparently required that checks for CONFIG_USB_GADGET_OMAP would be
> replaced with checks for CONFIG_USB_OMAP. Do so now for the remaining
> checks for CONFIG_USB_GADGET_OMAP, even though these checks have
> basically been broken since v3.1.
> 
> And, since we're touching this code, use the IS_ENABLED() macro, so
> things will now (hopefully) also work if USB_OMAP is modular.
> 
> Fixes: 193ab2a60700 ("usb: gadget: allow multiple gadgets to be built")
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> v2: us IS_ENABLED() as Felipe requested. Still untested.

Thanks applying into omap-for-v3.16/board.

Tony
