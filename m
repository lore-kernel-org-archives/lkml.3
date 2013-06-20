Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab3FTHVT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:21:19 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:62945 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753840Ab3FTHVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:21:17 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX182QkVjkOQHg7ZHOUqFCcnu
Date: Thu, 20 Jun 2013 00:21:14 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Roger Quadros <rogerq@ti.com>, stern@rowland.harvard.edu, balbi@ti.com,
        ruslan.bilovol@ti.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [RFC PATCH 2/6] mfd: omap-usb-host: Put pins in IDLE state on
 suspend
Message-ID: <20130620072112.GF5523@atomide.com>
References: <1371650753-11452-1-git-send-email-rogerq@ti.com>
 <1371650753-11452-3-git-send-email-rogerq@ti.com>
 <878v26815g.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878v26815g.fsf@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kevin Hilman <khilman@linaro.org> [130619 10:30]:
> Hi Roger,
> 
> Roger Quadros <rogerq@ti.com> writes:
> 
> > In order to support wake up from suspend use the pinctrl
> > framework to put the USB host pins in IDLE state during suspend.
> >
> > CC: Samuel Ortiz <sameo@linux.intel.com>
> > Signed-off-by: Roger Quadros <rogerq@ti.com>
> 
> You should use helpers for this now in the pinctrl core:
> 
>     http://lists.infradead.org/pipermail/linux-arm-kernel/2013-June/173514.html

Also see the thread "[PATCH] pinctrl: document the pinctrl PM states"
as we're still discussing how to deal with the various dynamic
pinctrl needs in a generic way. Meanwile, just make sure the other
patches work and don't break anything without this patch to
remove the dependency.

Regards,

Tony
