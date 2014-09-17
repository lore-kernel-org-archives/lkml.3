Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194AbaIQEuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 00:50:24 -0400
Received: from mail-by2on0101.outbound.protection.outlook.com ([207.46.100.101]:1489
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750900AbaIQEuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 00:50:22 -0400
X-Greylist: delayed 8886 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Sep 2014 00:50:22 EDT
Date: Wed, 17 Sep 2014 12:50:02 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Robin Gong <b38343@freescale.com>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <kernel@pengutronix.de>, <sre@kernel.org>, <dbaryshkov@gmail.com>,
        <dwmw2@infradead.org>, <grant.likely@linaro.org>,
        <linux@arm.linux.org.uk>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 1/3] ARM: dts: imx6: add pm_power_off support for
 i.mx6 chips
Message-ID: <20140917045001.GG4796@dragon>
References: <1410511739-31122-1-git-send-email-b38343@freescale.com>
 <1410511739-31122-2-git-send-email-b38343@freescale.com>
 <20140917021044.GD4796@dragon> <20140917034514.GF27452@Robin-OptiPlex-780>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140917034514.GF27452@Robin-OptiPlex-780>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(51704005)(199003)(189002)(105606002)(54356999)(4396001)(81342003)(83322001)(85306004)(99396002)(46102003)(77982003)(83072002)(97756001)(74662003)(50466002)(86362001)(110136001)(79102003)(84676001)(74502003)(92726001)(50986999)(80022003)(87936001)(97736003)(6806004)(81542003)(33656002)(93886004)(85852003)(107046002)(76482002)(83506001)(20776003)(92566001)(104016003)(68736004)(23726002)(57986006)(95666004)(102836001)(90102001)(26826002)(64706001)(21056001)(106466001)(46406003)(44976005)(31966008)(76176999)(47776003)(33716001)(558084003);DIR:OUT;SFP:1102;SCL:1;SRVR:SN2PR03MB046;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0337AFFE9A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 11:45:15AM +0800, Robin Gong wrote:
> > BTW, the commit log of the driver patch [[PATCH v2 2/3] ] should be
> > improved.
> > 
> > Shawn
> >
> You mean the above info need added into commit log ,right?

Yes, that's what I mean.

Shawn
