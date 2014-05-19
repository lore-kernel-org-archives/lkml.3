Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaESGKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 02:10:30 -0400
Received: from mail-bl2lp0210.outbound.protection.outlook.com ([207.46.163.210]:26413
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750801AbaESGK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 02:10:29 -0400
Date: Mon, 19 May 2014 13:51:16 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Paul Bolle <pebolle@tiscali.nl>
CC: Sascha Hauer <s.hauer@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: imx: remove unused defines
Message-ID: <20140519055109.GJ10685@dragon>
References: <1400140671.20469.7.camel@x220>
 <20140515122553.GF5858@pengutronix.de> <1400231369.20342.10.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1400231369.20342.10.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(24454002)(189002)(199002)(23726002)(77982001)(77096999)(6806004)(50466002)(83072002)(85852003)(19580395003)(74662001)(31966008)(57986004)(64706001)(74502001)(69596002)(68736004)(79102001)(80022001)(20776003)(83506001)(102836001)(4396001)(97756001)(21056001)(81542001)(87936001)(76482001)(81342001)(47776003)(86362001)(92566001)(92726001)(46102001)(76176999)(19580405001)(33656001)(558084003)(46406003)(33716001)(83322001)(81156002)(50986999)(54356999)(99396002)(44976005);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR03MB023;H:az84smr01.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 021670B4D2
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 11:09:29AM +0200, Paul Bolle wrote:
> None of the defines "for modules using static and dynamic DMA channels"
> are used. Remove these.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Applied, thanks.
