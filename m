Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbaIAJIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 05:08:13 -0400
Received: from mail-bn1bon0061.outbound.protection.outlook.com ([157.56.111.61]:48078
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752608AbaIAJIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 05:08:11 -0400
X-Greylist: delayed 1999 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Sep 2014 05:08:11 EDT
Date: Mon, 1 Sep 2014 16:34:38 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: vf610-twr: remove useless property for sound
 card.
Message-ID: <20140901083435.GA22559@dragon>
References: <1409278941-16975-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1409278941-16975-1-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130540340898973431;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009013)(6009001)(448002)(24454002)(199003)(189002)(51704005)(95666004)(76482001)(90102001)(74662001)(74502001)(46102001)(31966008)(106466001)(81156004)(33716001)(54356999)(50986999)(97756001)(97736001)(107046002)(50466002)(76176999)(86362001)(21056001)(47776003)(20776003)(558084003)(83322001)(64706001)(92566001)(102836001)(44976005)(92726001)(85852003)(83072002)(84676001)(19580405001)(19580395003)(85326001)(33656002)(83506001)(6806004)(87936001)(23726002)(104016003)(80022001)(26826002)(57986006)(77982001)(110136001)(85306004)(46406003)(79102001)(99396002)(81342001)(4396001)(69596002)(68736004)(81542001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB368;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03218BFD9F
Authentication-Results: spf=permerror (sender IP is 192.88.158.2)
 smtp.mailfrom=shawn.guo@linaro.org; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 10:22:21AM +0800, Xiubo Li wrote:
> This was added by:
> Commit 8128c4f36 ("ARM: dts: vf610-twr: Add simple-card support.")
> 
> This useless property may cause some confusions for users.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>

Applied, thanks.
