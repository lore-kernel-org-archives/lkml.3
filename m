Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbaGGFzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 01:55:33 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:2707
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750736AbaGGFzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 01:55:32 -0400
Date: Mon, 7 Jul 2014 13:55:23 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Fabian Frederick <fabf@skynet.be>
CC: <linux-kernel@vger.kernel.org>, Sascha Hauer <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/1] ARM: imx: use PTR_ERR_OR_ZERO
Message-ID: <20140707055521.GM30239@dragon>
References: <1404500590-21712-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1404500590-21712-1-git-send-email-fabf@skynet.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(199002)(24454002)(189002)(57986006)(81342001)(69596002)(76176999)(83322001)(83506001)(19580395003)(104016002)(95666004)(97756001)(68736004)(105606002)(76482001)(20776003)(54356999)(50466002)(81542001)(77982001)(50986999)(46102001)(33716001)(47776003)(92566001)(64706001)(558084003)(86362001)(33656002)(6806004)(26826002)(97736001)(19580405001)(107046002)(87936001)(21056001)(4396001)(92726001)(83072002)(46406003)(23726002)(85306003)(74502001)(85852003)(80022001)(84676001)(79102001)(102836001)(74662001)(44976005)(31966008)(106466001)(99396002)(110136001)(81156004);DIR:OUT;SFP:;SCL:1;SRVR:DM2PR03MB384;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02652BD10A
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 09:03:10PM +0200, Fabian Frederick wrote:
> replace IS_ERR/PTR_ERR
> 
> Cc: Shawn Guo <shawn.guo@freescale.com>
> Cc: Sascha Hauer <kernel@pengutronix.de>
> Cc: linux-arm-kernel@lists.infradead.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied, thanks.
