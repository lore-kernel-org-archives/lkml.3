Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934436Ab3BMQkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 11:40:12 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:44785 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759377Ab3BMQkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 11:40:09 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19nvnkAOsFoojtZPitC0FU/
Date: Wed, 13 Feb 2013 08:40:05 -0800
From: Tony Lindgren <tony@atomide.com>
To: Jon Hunter <jon-hunter@ti.com>
Cc: Sourav Poddar <sourav.poddar@ti.com>, balbi@ti.com,
        santosh.shilimkar@ti.com, b-cousson@ti.com, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] arm: dts: omap4-panda: Add I2c pinctrl data
Message-ID: <20130213164004.GE7144@atomide.com>
References: <1360747710-1532-1-git-send-email-sourav.poddar@ti.com>
 <511BB7CE.1020505@ti.com>
 <511BBA1B.9050501@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <511BBA1B.9050501@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jon Hunter <jon-hunter@ti.com> [130213 08:10]:
> On 02/13/2013 09:57 AM, Jon Hunter wrote:
> > On 02/13/2013 03:28 AM, Sourav Poddar wrote:
> > 
> > A quick look at the data manual shows that omap4430 and omap4460 has the
> > same pin mux options for i2c. Furthermore, the data manual shows only
> > one mux option for i2c1-4. Therefore, should these mux options be placed
> > in omap4.dtsi? Boards not using specific i2c controllers can disabled
> > them in there board dts file (same way we do for mmc).
> 
> I guess for i2c, a given omap4 board may use external pull-ups and not
> use the internal ones and so putting this in the omap4.dtsi may not be
> desirable. However, it seems that a common omap4-panda.dtsi could be
> used here.

Yes the mux options need to be board specific. If something is complex
and  common, it's best to put it into omap4-i2c1.dts file that can be
included from the board specific .dts files as needed.

Regards,

Tony
