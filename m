Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbaFUEoe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 00:44:34 -0400
Received: from mail-bn1blp0181.outbound.protection.outlook.com ([207.46.163.181]:10946
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751518AbaFUEob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 00:44:31 -0400
Date: Sat, 21 Jun 2014 12:44:20 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Nicolin Chen <nicoleotsuka@gmail.com>
CC: <vinod.koul@intel.com>, <s.hauer@pengutronix.de>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <rdunlap@infradead.org>, <dan.j.williams@intel.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>
Subject: Re: [PATCH] dma: imx-sdma: Add a new DMATYPE for Shared Peripheral
 ASRC
Message-ID: <20140621044418.GB6818@dragon>
References: <1402889465-23797-1-git-send-email-nicoleotsuka@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1402889465-23797-1-git-send-email-nicoleotsuka@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130477994677765818;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(24454002)(189002)(51704005)(76176999)(76482001)(19580405001)(21056001)(83322001)(46102001)(85852003)(1411001)(68736004)(44976005)(81542001)(50466002)(31966008)(64706001)(69596002)(92566001)(33716001)(84676001)(50986999)(86362001)(47776003)(20776003)(106466001)(83072002)(19580395003)(77982001)(81342001)(81156004)(102836001)(26826002)(97736001)(74502001)(74662001)(97756001)(33656002)(80022001)(104016002)(105596002)(6806004)(99396002)(85306003)(46406003)(558084003)(57986006)(87936001)(4396001)(54356999)(79102001)(83506001)(92726001)(95666004)(23726002);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB350;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0249EFCB0B
Authentication-Results: spf=softfail (sender IP is 192.88.158.2)
 smtp.mailfrom=shawn.guo@linaro.org; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 11:31:05AM +0800, Nicolin Chen wrote:
> Shared Peripheral ASRC, running on SPBA, needs to use shp sciprts for
> DMA transfer. So this patch just adds a new DMATYPE for it.
> 
> Signed-off-by: Nicolin Chen <nicoleotsuka@gmail.com>

Acked-by: Shawn Guo <shawn.guo@linaro.org>
