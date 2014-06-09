Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbaFICGk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 22:06:40 -0400
Received: from mail-bn1lp0140.outbound.protection.outlook.com ([207.46.163.140]:31277
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752570AbaFICGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 22:06:33 -0400
Date: Mon, 9 Jun 2014 10:06:12 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <grygorii.strashko@ti.com>,
        <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH] dt/documentation: add specification of dma bus
 information
Message-ID: <20140609020611.GW8860@dragon>
References: <1401981720-6946-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1401981720-6946-1-git-send-email-santosh.shilimkar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(189002)(199002)(24454002)(51914003)(81542001)(20776003)(47776003)(83072002)(81342001)(80022001)(97756001)(26826002)(86362001)(85852003)(6806004)(97736001)(92566001)(92726001)(99396002)(77982001)(84676001)(68736004)(83322001)(19580405001)(44976005)(46406003)(19580395003)(33716001)(83506001)(77096999)(104016001)(50986999)(54356999)(76176999)(87936001)(31966008)(50466002)(76482001)(46102001)(74662001)(23726002)(74502001)(64706001)(57986005)(4396001)(79102001)(33656002)(21056001)(102836001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB407;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 02379661A3
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 11:22:00AM -0400, Santosh Shilimkar wrote:
> Recently we introduced the generic device tree infrastructure for couple of DMA
> bus parameter, dma-ranges and dma-coherent. Update the documentation so that
> its useful for future users.
> 
> The "dma-ranges" property is intended to be used for describing the
> configuration of DMA bus RAM addresses and its offset w.r.t CPU addresses.
> 
> The "dma-coherent" property is intended to be used for identifying devices
> supported coherent DMA operations.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Pawel Moll <pawel.moll@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
> Cc: Shawn Guo <shawn.guo@freescale.com>
> Cc: Kumar Gala <galak@codeaurora.org>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

Thanks for the documentation.  I think it's definitely useful for future
users of the binding.

Acked-by: Shawn Guo <shawn.guo@freescale.com>
