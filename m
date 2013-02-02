Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab3BBSQy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 13:16:54 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:62069 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757210Ab3BBSQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 13:16:51 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18DJNUqvOBHpqcf6e0ttSH1
Date: Sat, 2 Feb 2013 10:16:43 -0800
From: Tony Lindgren <tony@atomide.com>
To: Matt Porter <mporter@ti.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Dan Williams <djbw@fb.com>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 01/10] ARM: davinci: move private EDMA API to
 arm/common
Message-ID: <20130202181643.GD577@atomide.com>
References: <1359742975-10421-1-git-send-email-mporter@ti.com>
 <1359742975-10421-2-git-send-email-mporter@ti.com>
 <5022f635a527470dbd0be932063e9cd2@DFLE72.ent.ti.com>
 <20130201184915.GP2244@beef>
 <2077c13e12314dc3adc8e5b653855da0@DFLE72.ent.ti.com>
 <20130201185959.GQ2244@beef>
 <e9be6668da8b4372a04687847daa1d8c@DFLE72.ent.ti.com>
 <20130202180747.GS2244@beef>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130202180747.GS2244@beef>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matt Porter <mporter@ti.com> [130202 10:10]:
> If it doesn't work, work with Vinod to fix the api. It's expected,
> I'm working on dmaengine API changes right now to deal with a
> limitation of EDMA that needs to be abstracted.

Regarding the DMA API limitations, I'm only aware of lack of capability
to configure autoincrement at the device end. And that keeps us from
converting all GPMC related devices using omap SDMA to use the DMA API.

Are there other limitations currently known with the DMA API?

Regards,

Tony
