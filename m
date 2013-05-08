Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab3EHXwj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 19:52:39 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:46398 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3EHXwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 19:52:37 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/M4TnI24iej6sTO1k7z+GB
Date: Wed, 8 May 2013 16:52:32 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: balbi@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP2+: omap-usb-host: clean up pin mux setup code
Message-ID: <20130508235232.GW32546@atomide.com>
References: <1366624673-2684-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366624673-2684-1-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [130422 03:02]:
> The USB host pins are named quite differently between OMAP3 and
> OMAP4+ SoCs. To make this managable in code, we create a pin mapping
> table (pin_names) that maps pin function to pin name.
> 
> This pin mapping table is populated at runtime based on a pin
> name template. Templates are provided for OMAP3 and 4 SoCs.
> 
> The setup_io_mux() function uses the pin mapping table to
> setup the pin mux.
> 
> The resulting code is a lot more clean, manageable and scalable.

I'm planning to drop all the omap4 pdata soonish. Will post some
patches after -rc1 to do that. Do you still need this patch
considering that?

Regards,

Tony
