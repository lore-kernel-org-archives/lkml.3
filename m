Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934574AbaGPGLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 02:11:35 -0400
Received: from mail-bn1lp0142.outbound.protection.outlook.com ([207.46.163.142]:20786
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932717AbaGPGLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 02:11:33 -0400
Date: Wed, 16 Jul 2014 14:11:20 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Stefan Agner <stefan@agner.ch>
CC: <mkl@pengutronix.de>, <kernel@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/4] ARM: vf610: add FlexCAN support
Message-ID: <20140716061118.GN2197@dragon>
References: <cover.1405428166.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1405428166.git.stefan@agner.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(24454002)(83322001)(6806004)(107046002)(95666004)(23726002)(4396001)(85852003)(92566001)(68736004)(79102001)(81542001)(46406003)(104016003)(106466001)(558084003)(81156004)(92726001)(47776003)(83072002)(69596002)(77982001)(110136001)(50466002)(99396002)(84676001)(87936001)(44976005)(54356999)(33716001)(76482001)(57986006)(102836001)(33656002)(85306003)(74662001)(31966008)(81342001)(46102001)(76176999)(21056001)(50986999)(83506001)(86362001)(20776003)(105606002)(97756001)(26826002)(64706001)(80022001)(97736001)(74502001);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB568;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0274272F87
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Shawn.Guo@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 02:56:17PM +0200, Stefan Agner wrote:
> Stefan Agner (4):
>   ARM: dts: vf610: add FlexCAN node
>   ARM: imx: clk-vf610: fix FlexCAN clock gating

Applied these two, thanks.

>   can: flexcan: switch on clocks before accessing ecr register
>   can: flexcan: add vf610 support for FlexCAN
