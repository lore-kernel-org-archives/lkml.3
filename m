Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750997AbaIJDZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 23:25:19 -0400
Received: from mail-by2on0103.outbound.protection.outlook.com ([207.46.100.103]:49664
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750719AbaIJDZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 23:25:17 -0400
X-Greylist: delayed 855 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2014 23:25:17 EDT
Date: Wed, 10 Sep 2014 11:10:48 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Shengjiu Wang <shengjiu.wang@freescale.com>
CC: <kernel@pengutronix.de>, <linux@arm.linux.org.uk>, <robh+dt@kernel.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V1 0/3] refine the ssi clock for imx6sl, and update dts
 file.
Message-ID: <20140910031046.GA18566@dragon>
References: <cover.1410253534.git.shengjiu.wang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1410253534.git.shengjiu.wang@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019019)(6009001)(189002)(199003)(51704005)(24454002)(76176999)(6806004)(50466002)(31966008)(33656002)(74662001)(81342001)(54356999)(50986999)(83322001)(81542001)(44976005)(68736004)(102836001)(104016003)(21056001)(33716001)(90102001)(99396002)(74502001)(85306004)(4396001)(20776003)(47776003)(64706001)(92566001)(85852003)(83072002)(92726001)(80022001)(86362001)(97756001)(26826002)(84676001)(83506001)(57986006)(87936001)(23726002)(79102001)(77982001)(76482001)(46102001)(107046002)(105606002)(95666004)(106466001)(46406003)(97736003)(110136001)(32563001);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR03MB324;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 033054F29A
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 05:13:24PM +0800, Shengjiu Wang wrote:
> This serial patch is for refining the ssi clock tree for imx6sl,
> and update imx6qdl and imx6sl dts file.
> 
> Shengjiu Wang (3):
>   ARM: clk-imx6sl: refine clock tree for SSI
>   ARM: dts: imx6qdl: add baud clock and clock-names for ssi
>   ARM: dts: imx6sl: add baud clock and clock-names for ssi

Applied all, thanks.
