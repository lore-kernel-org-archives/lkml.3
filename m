Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbaFPKlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 06:41:32 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:14310 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754997AbaFPKl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 06:41:29 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18BOfdnw/TSFqkw5Z20ybS/
Date: Mon, 16 Jun 2014 03:41:26 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: Sricharan R <r.sricharan@ti.com>, Sourav Poddar <sourav.poddar@ti.com>,
        bcousson@baylibre.com, devicetree@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Nayak, Rajendra" <rnayak@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [Resend/PATCH] arm: dts: dra7: Add qspi device.
Message-ID: <20140616104126.GC17845@atomide.com>
References: <1399374445-16456-1-git-send-email-sourav.poddar@ti.com>
 <20140506165254.GN18474@atomide.com>
 <53886CB7.4070104@ti.com>
 <538884C4.5070304@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538884C4.5070304@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [140530 06:19]:
> On 05/30/2014 06:34 AM, Sricharan R wrote:
> > Hi,
> > 
> > On Tuesday 06 May 2014 10:22 PM, Tony Lindgren wrote:
> >> * Sourav Poddar <sourav.poddar@ti.com> [140506 04:08]:
> >>> These add device tree entry for qspi controller driver on dra7-evm.
> >> Thanks applying into omap-for-v3.16/dt.
> > There is a problem with this. The qspi node defines crossbar number
> >  as its interrupt number. Since the crossbar dts patches are not yet
> >  there, this causes a warning during boot.  So interrupts = < >
> >  property should be removed from DT and added later by crossbar series.
> > 
> 
> https://github.com/nmenon/kernel-test-logs/blob/next-20140530/omap2plus_defconfig/dra7.txt#L151
> as an indication of the warning.
> 
> Tony,
> Would you prefer a patch on top of omap-for-v3.16/dt-v2 branch?

Sorting through my mailbox.. If this is still an issue a
fix against v3.16-rc1 please.

Regards,

Tony
