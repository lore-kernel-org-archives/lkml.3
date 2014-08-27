Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157AbaH0GjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 02:39:12 -0400
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:29634
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754305AbaH0GjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 02:39:11 -0400
Date: Wed, 27 Aug 2014 14:38:35 +0800
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
Subject: Re: [PATCH v2 09/26] irqchip: mxs: convert to handle_domain_irq
Message-ID: <20140827063834.GC28777@dragon>
References: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
 <1409047421-27649-10-git-send-email-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1409047421-27649-10-git-send-email-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(199003)(189002)(24454002)(68736004)(23726002)(90102001)(79102001)(105606002)(20776003)(95666004)(4396001)(57986006)(107046002)(19580405001)(26826002)(31966008)(77982001)(106466001)(33716001)(33656002)(81542001)(50466002)(46406003)(92726001)(97756001)(83322001)(44976005)(85852003)(74662001)(6806004)(110136001)(87936001)(102836001)(104016003)(21056001)(74502001)(97736001)(84676001)(83072002)(99396002)(47776003)(80022001)(558084003)(86362001)(64706001)(54356999)(50986999)(83506001)(85306004)(76482001)(19580395003)(92566001)(46102001)(76176999)(81342001);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB573;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0316567485
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 11:03:24AM +0100, Marc Zyngier wrote:
> Use the new handle_domain_irq method to handle interrupts.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Shawn Guo <shawn.guo@freescale.com>
