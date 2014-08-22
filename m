Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbaHVIIG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 04:08:06 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:56544
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754296AbaHVIIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 04:08:00 -0400
Date: Fri, 22 Aug 2014 16:07:28 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <peter.chen@freescale.com>, <s.hauer@pengutronix.de>,
        <kernel@pengutronix.de>, <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <jingchang.lu@freescale.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND v2 0/7] vf610: Add USB support
Message-ID: <20140822080727.GD2540@dragon>
References: <cover.1408391385.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1408391385.git.stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(24454002)(199003)(33656002)(69596002)(26826002)(68736004)(92566001)(31966008)(76482001)(95666004)(92726001)(23726002)(46102001)(44976005)(81156004)(47776003)(105606002)(50986999)(99396002)(90102001)(85306004)(74502001)(81342001)(102836001)(33716001)(106466001)(4396001)(83072002)(74662001)(87936001)(46406003)(77982001)(57986006)(83506001)(50466002)(97756001)(80022001)(83322001)(76176999)(110136001)(54356999)(86362001)(81542001)(21056001)(6806004)(64706001)(79102001)(104016003)(20776003)(97736001)(107046002)(84676001)(85852003)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB473;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0311124FA9
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 10:07:10PM +0200, Stefan Agner wrote:
> Stefan Agner (7):
>   ARM: dts: vf610: Add USB PHY and controller
>   ARM: imx: clk-vf610: Add USBPHY clocks
...
>   ARM: dts: vf610: Add usbmisc for non-core registers
...
>   ARM: dts: vf610-colibri: Add USB support
>   ARM: dts: vf610-twr: Add USB support

Applied these 5 patches, thanks.
