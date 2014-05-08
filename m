Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbaEHDib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 23:38:31 -0400
Received: from mail-by2on0097.outbound.protection.outlook.com ([207.46.100.97]:50256
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752676AbaEHDi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 23:38:29 -0400
Date: Thu, 8 May 2014 11:38:18 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Juan Solano <jsm@jsolano.com>
CC: <kernel@pengutronix.de>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: i.MX27 pca100: remove deprecated IRQF_DISABLED
Message-ID: <20140508033817.GE2794@dragon>
References: <1399475399-8770-1-git-send-email-jsm@jsolano.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1399475399-8770-1-git-send-email-jsm@jsolano.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(189002)(199002)(51704005)(24454002)(77982001)(44976005)(83506001)(69596002)(68736004)(33656001)(33716001)(19580395003)(83322001)(19580405001)(64706001)(2009001)(6806004)(21056001)(81156002)(87936001)(558084003)(86362001)(23726002)(76176999)(54356999)(80022001)(76482001)(50986999)(46406003)(77096999)(4396001)(84676001)(31966008)(74662001)(74502001)(57986002)(97736001)(97756001)(81342001)(99396002)(92726001)(20776003)(83072002)(47776003)(79102001)(85852003)(46102001)(92566001)(50466002)(81542001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB026;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 0205EDCD76
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 05:09:59PM +0200, Juan Solano wrote:
> This flag is a NOOP and can be removed now.
> 
> Signed-off-by: Juan Solano <jsm@jsolano.com>

Applied, thanks.
