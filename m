Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819AbaKUIxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 03:53:53 -0500
Received: from mail-bl2on0140.outbound.protection.outlook.com ([65.55.169.140]:43488
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752508AbaKUIxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 03:53:52 -0500
Date: Fri, 21 Nov 2014 17:00:56 +0800
From: Robin Gong <b38343@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: Soeren Moch <smoch@web.de>, <kernel@pengutronix.de>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux@arm.linux.org.uk>, <sre@kernel.org>, <dbaryshkov@gmail.com>,
        <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/3] ARM: dts: imx6: add pm_power_off support for i.mx6
 chips
Message-ID: <20141121090053.GA28992@Robin-OptiPlex-780>
References: <1415780439-29728-1-git-send-email-b38343@freescale.com>
 <1415780439-29728-2-git-send-email-b38343@freescale.com>
 <20141119031823.GC27759@dragon> <546C2A13.3010307@web.de>
 <20141119055006.GA27258@Robin-OptiPlex-780> <20141119060442.GD27759@dragon>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141119060442.GD27759@dragon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(51704005)(199003)(189002)(24454002)(33716001)(87936001)(46102003)(97736003)(99396003)(93886004)(31966008)(33656002)(120916001)(69596002)(23726002)(83506001)(68736004)(97756001)(84676001)(4396001)(64706001)(47776003)(20776003)(110136001)(92566001)(102836001)(92726001)(104016003)(50466002)(50986999)(76176999)(6806004)(44976005)(54356999)(106466001)(46406003)(81156004)(21056001)(77156002)(62966003)(105606002)(95666004)(107046002)(42262002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0629;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0629;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0629;
X-Forefront-PRVS: 0402872DA1
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=yibin.gong@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0629;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0693;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Shawn and Soeren. :)
On Wed, Nov 19, 2014 at 02:04:43PM +0800, Shawn Guo wrote:
> On Wed, Nov 19, 2014 at 01:50:07PM +0800, Robin Gong wrote:
> > Sorry, the patch resent wrongly...
> > Hi Shawn, Can you apply the first v4 patches on Sep 26, or I resend it again? 
> 
> I fixed it up and tested the series on my imx6q-sabresd board.
> 
> Applied the series.
> 
> Shawn
