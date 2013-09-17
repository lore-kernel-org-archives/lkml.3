Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab3IQXSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 19:18:07 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:13981 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752890Ab3IQXSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 19:18:05 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/MMQcWAr9g+fV3Ty9PdU+V
Date: Tue, 17 Sep 2013 16:17:44 -0700
From: Tony Lindgren <tony@atomide.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Dave Martin <Dave.Martin@arm.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        "nm@ti.com" <nm@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "aaro.koskinen@iki.fi" <aaro.koskinen@iki.fi>,
        "pdeschrijver@nvidia.com" <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 1/2] ARM: OMAP: Add secure function omap_smc3()
 which calling instruction smc #1
Message-ID: <20130917231744.GJ9994@atomide.com>
References: <20130916171023.GA17477@localhost.localdomain>
 <20130917154331.GA9994@atomide.com>
 <201309171753.24433@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201309171753.24433@pali>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pali Rohár <pali.rohar@gmail.com> [130917 09:01]:
> On Tuesday 17 September 2013 17:43:31 Tony Lindgren wrote:
> > Have you guys checked how this works with the recently posted
> > "[PATCH v6 0/5] ARM: support for Trusted Foundations secure
> > monitor" series?
> 
> this code looks like some Tegra and "Trusted Foundations" 
> specific. There is Note: The API followed by Trusted Foundations 
> does *not* follow the SMC calling conventions.  Also code calling 
> smc #0 instruction, so in my opinion for rx51 it is useless.

OK, so still no generic SMC code then :( This patch is fine
with me.
 
> Tony, can you include this two rx51 secure patches (patch v4 1/2 
> and patch v2 2/2)? Or is there some any other problem?

No other comments on this patch, I'll post some comments on the
v2 2/2 patch considering we're moving to device tree based
booting.

Regards,

Tony
