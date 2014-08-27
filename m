Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300AbaH0GlZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 02:41:25 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:49144
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754451AbaH0GlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 02:41:24 -0400
Date: Wed, 27 Aug 2014 14:40:39 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Marc Zyngier <marc.zyngier@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux@openrisc.net>,
        <linux@arm.linux.org.uk>, <kernel@pengutronix.de>, <tony@atomide.com>,
        <catalin.marinas@arm.com>, <will.deacon@arm.com>, <jonas@southpole.se>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>, <shc_work@mail.ru>,
        <baohua@kernel.org>, <maxime.ripard@free-electrons.com>,
        <khilman@linaro.org>, <sboyd@codeaurora.org>,
        <lorenzo.pieralisi@arm.com>, <larry.bassel@linaro.org>,
        <mark.rutland@arm.com>, <sudeep.holla@arm.com>,
        <stefan.kristiansson@saunalahti.fi>, <vkale@apm.com>,
        <schwidefsky@de.ibm.com>
Subject: Re: [PATCH v2 23/26] ARM: imx: tzic: convert to handle_domain_irq
Message-ID: <20140827064038.GE28777@dragon>
References: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
 <1409047421-27649-24-git-send-email-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1409047421-27649-24-git-send-email-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(199003)(189002)(24454002)(106466001)(23726002)(86362001)(81542001)(80022001)(20776003)(44976005)(19580405001)(19580395003)(4396001)(77982001)(110136001)(83322001)(81342001)(64706001)(69596002)(6806004)(87936001)(81156004)(68736004)(33656002)(46102001)(76176999)(33716001)(47776003)(107046002)(99396002)(105606002)(50986999)(558084003)(95666004)(104016003)(83506001)(97756001)(74502001)(76482001)(97736001)(57986006)(102836001)(46406003)(85306004)(54356999)(84676001)(85852003)(83072002)(21056001)(26826002)(31966008)(79102001)(50466002)(92726001)(74662001)(92566001)(90102001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB563;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0316567485
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 11:03:38AM +0100, Marc Zyngier wrote:
> Use the new handle_domain_irq method to handle interrupts.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Shawn Guo <shawn.guo@freescale.com>
