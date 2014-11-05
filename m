Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbaKEROO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:14:14 -0500
Received: from mail-bl2on0091.outbound.protection.outlook.com ([65.55.169.91]:6457
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755128AbaKEROL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:14:11 -0500
X-Greylist: delayed 609 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Nov 2014 12:14:11 EST
Date: Wed, 5 Nov 2014 09:14:00 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Heiko Stuebner <heiko@sntech.de>, <linux-sh@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <linux-rockchip@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>
Subject: Re: [PATCH 5/7] pinctrl: Add driver for Zynq
References: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com>
 <1415041531-15520-6-git-send-email-soren.brinkmann@xilinx.com>
 <5459B1B5.6030001@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5459B1B5.6030001@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21076.007
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <77a9809bf6a8476c80d9308a7d3b1ac0@BN1AFFO11FD047.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(24454002)(164054003)(199003)(189002)(51704005)(377424004)(21056001)(44976005)(95666004)(106466001)(4396001)(53416004)(85202003)(102836001)(85182001)(83506001)(87936001)(31966008)(107046002)(54356999)(50986999)(23676002)(92566001)(86362001)(20776003)(47776003)(64706001)(120916001)(77156002)(77096003)(110136001)(104016003)(99396003)(108616004)(76176999)(6806004)(46102003)(74316001)(50466002)(33646002)(62966003)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB044;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:3;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB044;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0386B406AA
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-05 at 06:12AM +0100, Andreas Färber wrote:
> Am 03.11.2014 um 20:05 schrieb Soren Brinkmann:
> > +enum zynq_pinmux_functions {
> > +	ZYNQ_PMUX_ethernet0,
> > +	ZYNQ_PMUX_ethernet1,
> > +	ZYNQ_PMUX_mdio0,
> > +	ZYNQ_PMUX_mdio1,
> > +	ZYNQ_PMUX_qspi0,
> > +	ZYNQ_PMUX_qspi1,
> > +	ZYNQ_PMUX_qspi_fbclk,
> > +	ZYNQ_PMUX_qspi_cs1,
> 
> Are usb0 and usb1 intentionally missing in this patch for lack of
> upstream USB driver? If so, then please mention what you left out in the
> commit message.

I don't know how that could happen, but no, it's not intentionally
missing, let's call it accidentally. It just slipped through. Don't
ask me how I could miss USB.

	Thanks,
	Sören
