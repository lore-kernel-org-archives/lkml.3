Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759706Ab3HNJop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:44:45 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:57148 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752919Ab3HNJol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:44:41 -0400
Message-ID: <1376473404.2132.10.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [RFC 2/2] usb: dwc3: Add Qualcomm DWC3 glue layer driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com, rob@landley.net,
        gregkh@linuxfoundation.org, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
Date: Wed, 14 Aug 2013 12:43:24 +0300
In-Reply-To: <20130809132349.GC12041@radagast>
References: <1375789991-30041-1-git-send-email-iivanov@mm-sol.com>
	 <1375789991-30041-3-git-send-email-iivanov@mm-sol.com>
	 <20130809132349.GC12041@radagast>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

On Fri, 2013-08-09 at 16:23 +0300, Felipe Balbi wrote:

<snip>

> 
> > +	/*
> > +	 * DWC3 Core requires its CORE CLK (aka master / bus clk) to
> > +	 * run at 125Mhz in SSUSB mode and >60MHZ for HSUSB mode.
> > +	 */
> > +	clk_set_rate(mdwc->core_clk, 125000000);
> 
> if this is dwc3's core clock, why don't we teach dwc3.ko about this
> requirement ? Just make sure to have it optional, since x86 and OMAP
> wouldn't need direct fiddling with the clocks.

I believe this is Qualcomm specific requirement. Something is modified
inside DWC in respect of the clocks. I will like to keep this here, in
the glue layer driver.

Regards,
Ivan


