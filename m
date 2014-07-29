Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbaG2JWx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:22:53 -0400
Received: from mail-by2lp0236.outbound.protection.outlook.com ([207.46.163.236]:56247
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753298AbaG2JWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:22:50 -0400
X-Greylist: delayed 5954 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jul 2014 05:22:49 EDT
Date: Tue, 29 Jul 2014 17:22:37 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <peter.chen@freescale.com>, <s.hauer@pengutronix.de>,
        <b35083@freescale.com>, <jingchang.lu@freescale.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/7] vf610: Add USB support
Message-ID: <20140729092236.GH24750@dragon>
References: <cover.1406558450.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1406558450.git.stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(24454002)(189002)(199002)(74502001)(74662001)(23726002)(21056001)(44976005)(4396001)(81342001)(31966008)(76482001)(83322001)(99396002)(85852003)(95666004)(68736004)(104016003)(83072002)(6806004)(26826002)(92726001)(92566001)(47776003)(46102001)(33716001)(64706001)(20776003)(33656002)(97736001)(97756001)(85306003)(110136001)(80022001)(102836001)(86362001)(107046002)(50466002)(46406003)(79102001)(57986006)(83506001)(106466001)(87936001)(105606002)(81542001)(77982001)(84676001)(54356999)(50986999)(76176999);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0769;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0287BBA78D
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2014 at 04:57:26PM +0200, Stefan Agner wrote:
> Stefan Agner (7):
>   ARM: dts: vf610: Add USB PHY and controller
>   ARM: imx: clk-vf610: Add USBPHY clocks
...
>   ARM: dts: vf610: Add usbmisc for non-core registers
...
>   ARM: dts: vf610-colibri: Add USB support
>   ARM: dts: vf610-twr: Add USB support

These 'ARM: ...' patches look fine to me, and I will apply them on IMX
tree once the driver changes are accepted.

Shawn
