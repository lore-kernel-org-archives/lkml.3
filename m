Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbaIEAoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 20:44:07 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:54213
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754245AbaIEAoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 20:44:05 -0400
Date: Fri, 5 Sep 2014 08:43:47 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Shengjiu Wang <shengjiu.wang@freescale.com>
CC: <kernel@pengutronix.de>, <linux@arm.linux.org.uk>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V1 1/2] ARM: clk-imx6q: refine clock tree for ASRC
Message-ID: <20140905004346.GF10809@dragon>
References: <98d2985de76fa84525e9958522bd371a34ff84f0.1409824001.git.shengjiu.wang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <98d2985de76fa84525e9958522bd371a34ff84f0.1409824001.git.shengjiu.wang@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(24454002)(51704005)(199003)(105606002)(86362001)(92566001)(81542001)(21056001)(92726001)(81342001)(83506001)(110136001)(106466001)(95666004)(80022001)(76482001)(64706001)(84676001)(87936001)(85852003)(83072002)(50466002)(107046002)(20776003)(47776003)(77982001)(85306004)(33656002)(79102001)(46102001)(102836001)(50986999)(23726002)(90102001)(74662001)(31966008)(74502001)(99396002)(558084003)(97756001)(54356999)(76176999)(97736001)(26826002)(4396001)(44976005)(19580405001)(19580395003)(6806004)(83322001)(46406003)(104016003)(57986006)(68736004)(33716001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB330;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0325F6C77B
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 05:48:58PM +0800, Shengjiu Wang wrote:
> ASRC has "asrc", "asrc_ipg", "asrc_mem" clocks, and they share
> the same gate bits.
> 
> Signed-off-by: Shengjiu Wang <shengjiu.wang@freescale.com>

Applied both, thanks.
