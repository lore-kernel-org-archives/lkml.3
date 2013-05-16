Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239Ab3EPW6P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 18:58:15 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:64553 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754308Ab3EPW6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 18:58:14 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18clQVmopK9ysB81kIt/N1A
Date: Thu, 16 May 2013 15:58:10 -0700
From: Tony Lindgren <tony@atomide.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mfd: twl-core: convert to module_i2c_driver()
Message-ID: <20130516225810.GQ5600@atomide.com>
References: <1366723151-23209-1-git-send-email-grygorii.strashko@ti.com>
 <1366723151-23209-3-git-send-email-grygorii.strashko@ti.com>
 <20130516221710.GU22822@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130516221710.GU22822@zurbaran>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Samuel Ortiz <sameo@linux.intel.com> [130516 15:22]:
> Hi Grygorii,
> 
> On Tue, Apr 23, 2013 at 04:19:10PM +0300, Grygorii Strashko wrote:
> > Shift TWL initialization to module/device init layer, because I2C now is
> > not initialized on subsys init layer and shifted to module/device init
> > layer instead.
> > 
> > The I2C <--> TWL dependency should be resolved in drivers/Makefile now.
> >
> > Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> > Cc: linux-omap@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > 
> > Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> > ---
> >  drivers/mfd/twl-core.c |   12 +-----------
> >  1 file changed, 1 insertion(+), 11 deletions(-)
> I applied this one to mfd-next for now, and will move it to mfd-fixes if
> someone confirms that this is indeed a fix.

Thanks, AFAIK it can wait until v3.11 merge window.

Regards,

Tony
