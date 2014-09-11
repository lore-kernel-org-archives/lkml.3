Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbaIKICr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:02:47 -0400
Received: from mail-by2on0125.outbound.protection.outlook.com ([207.46.100.125]:6368
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751290AbaIKICn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:02:43 -0400
Date: Thu, 11 Sep 2014 16:02:23 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Robin Gong <b38343@freescale.com>
CC: <kernel@pengutronix.de>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: dts: imx6dl: disable dma support for spi on
 i.mx6dl
Message-ID: <20140911080222.GG18566@dragon>
References: <1410327012-31185-1-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1410327012-31185-1-git-send-email-b38343@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(24454002)(51704005)(199003)(189002)(83072002)(85852003)(92566001)(68736004)(44976005)(87936001)(6806004)(19580395003)(19580405001)(26826002)(83322001)(84676001)(81542001)(23726002)(81342001)(83506001)(86362001)(64706001)(92726001)(47776003)(20776003)(97756001)(80022001)(95666004)(99396002)(50986999)(104016003)(57986006)(106466001)(105606002)(97736003)(107046002)(110136001)(76176999)(54356999)(90102001)(85306004)(46102001)(102836001)(33656002)(4396001)(77982001)(21056001)(79102001)(50466002)(76482001)(31966008)(74662001)(74502001)(46406003)(33716001)(32563001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR03MB037;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03319F6FEF
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 01:30:12PM +0800, Robin Gong wrote:
> There is one weird data in rxfifo after one full rx/tx transfer
> done sometimes. It looks a design issue and hard to workaround
> totally, so disable dma functhion here. And will re-enable it
> once the root cause found.
> 
> Signed-off-by: Robin Gong <b38343@freescale.com>

Applied, thanks.
