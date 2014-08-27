Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253AbaH0Gkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 02:40:37 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:21490
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754667AbaH0Gkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 02:40:36 -0400
Date: Wed, 27 Aug 2014 14:40:06 +0800
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
Subject: Re: [PATCH v2 22/26] ARM: imx: avic: convert to handle_domain_irq
Message-ID: <20140827064005.GD28777@dragon>
References: <1409047421-27649-1-git-send-email-marc.zyngier@arm.com>
 <1409047421-27649-23-git-send-email-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1409047421-27649-23-git-send-email-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(51704005)(24454002)(199003)(46102001)(81542001)(86362001)(92566001)(92726001)(33716001)(50466002)(90102001)(84676001)(77982001)(81342001)(87936001)(4396001)(99396002)(79102001)(83072002)(76482001)(558084003)(83506001)(85852003)(20776003)(64706001)(80022001)(104016003)(47776003)(85306004)(95666004)(106466001)(31966008)(105606002)(102836001)(44976005)(19580405001)(6806004)(50986999)(68736004)(26826002)(19580395003)(33656002)(57986006)(97736001)(74502001)(21056001)(54356999)(76176999)(110136001)(23726002)(74662001)(97756001)(46406003)(83322001)(107046002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB571;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0316567485
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 11:03:37AM +0100, Marc Zyngier wrote:
> Use the new handle_domain_irq method to handle interrupts.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Shawn Guo <shawn.guo@freescale.com>
