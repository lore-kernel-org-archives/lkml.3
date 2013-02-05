Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab3BES3D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 13:29:03 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:62205 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754317Ab3BES27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 13:28:59 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19qV3umoTD2R+aiJfb4ZGl8
Date: Tue, 5 Feb 2013 10:28:49 -0800
From: Tony Lindgren <tony@atomide.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Sergei Shtylyov <sshtylyov@mvista.com>, Matt Porter <mporter@ti.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Chris Ball <cjb@laptop.org>, "Cousson, Benoit" <b-cousson@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to
 arm/common
Message-ID: <20130205182848.GJ25185@atomide.com>
References: <1359742975-10421-1-git-send-email-mporter@ti.com>
 <1359742975-10421-2-git-send-email-mporter@ti.com>
 <5022f635a527470dbd0be932063e9cd2@DFLE72.ent.ti.com>
 <20130201184915.GP2244@beef>
 <510C1D0E.6030401@mvista.com>
 <20130201185820.GE29898@arwen.pp.htv.fi>
 <510C2A47.1090607@mvista.com>
 <20130201205600.GA31762@arwen.pp.htv.fi>
 <20130201213003.GW2637@n2100.arm.linux.org.uk>
 <20130204154153.GA18237@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130204154153.GA18237@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Felipe Balbi <balbi@ti.com> [130204 07:46]:
> 
> Current DMA abstraction is quite poor, for example there's no way to
> compile support for multiple DMA engines. Code also makes certain, IMO
> unnecessary, assumptions about the underlying DMA engine (abstraction is
> poor, as said above but it we could follow MUSB's programming guide when
> it comes to programming DMA transfers).
> 
> Considering all of the above, it's far better to use DMA engine and get
> rid of all the mess.

How about just disable MUSB DMA support if ARCH_MULTIPLATFORM for now?
That way MUSB can be fixed up first to support ARCH_MULTIPLATFORM
using PIO while sorting out the DMA related issues.

Regards,

Tony
