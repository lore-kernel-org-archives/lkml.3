Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967360AbaFRO3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:29:12 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:3669
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756571AbaFRO3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:29:09 -0400
Date: Wed, 18 Jun 2014 22:28:46 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
CC: Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] ARM: dts: imx6: add support for Ka-Ro TX6 modules
Message-ID: <20140618142845.GN8860@dragon>
References: <1402578317-12566-1-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402578317-12566-1-git-send-email-LW@KARO-electronics.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(51704005)(24454002)(189002)(199002)(97736001)(26826002)(74662001)(81156003)(102836001)(84676001)(50466002)(79102001)(92726001)(19580395003)(44976005)(85306003)(87936001)(74502001)(46102001)(86362001)(69596002)(68736004)(47776003)(92566001)(76482001)(54356999)(50986999)(76176999)(23756003)(21056001)(20776003)(80022001)(99396002)(81542001)(85852003)(64706001)(31966008)(33716001)(77982001)(6806004)(19580405001)(83506001)(81342001)(83322001)(57986006)(33656002)(83072002)(95666004)(104016002)(4396001)(105606002);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0301MB0632;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02462830BE
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 03:05:17PM +0200, Lothar Waﬂmann wrote:
> This patch adds support for the Ka-Ro electronics GmbH TX6 modules.
> There are five distinct module types with either i.MX6Q or i.MX6DL and
> LVDS or LCD display interface and one DTS file for a complete system
> with an i.MX6DL based TX6 module and a baseboard mounted on the back
> of a display (imx6dl-tx6dl-comtft.dts).
> 
> Changes wrt. v1
> - addressed comments by Shawn Guo
> 
> 
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>

Applied, thanks.
