Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351AbaIXX6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 19:58:21 -0400
Received: from mail-bn1bon0077.outbound.protection.outlook.com ([157.56.111.77]:5472
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750725AbaIXX6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 19:58:19 -0400
X-Greylist: delayed 26574 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Sep 2014 19:58:19 EDT
Date: Wed, 24 Sep 2014 16:58:14 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
CC: <sebastian.hesselbarth@gmail.com>, <Peter.Chen@freescale.com>,
        <balbi@ti.com>, <p.zabel@pengutronix.de>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 07/12] usb: chipidea: add a usb2 driver for ci13xxx
References: <1411468088-5702-1-git-send-email-antoine.tenart@free-electrons.com>
 <1411468088-5702-8-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1411468088-5702-8-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20972.003
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <1a0ed130-a53d-42df-9f6a-994c5b68755c@BN1BFFO11FD031.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(377424004)(164054003)(189002)(199003)(24454002)(19580395003)(20776003)(83072002)(85852003)(47776003)(85306004)(107046002)(21056001)(23676002)(19580405001)(77982003)(83506001)(80022003)(81542003)(46102003)(90102001)(44976005)(79102003)(64706001)(74662003)(74502003)(83322001)(81342003)(4396001)(86362001)(31696002)(33646002)(76482002)(10300001)(31966008)(120916001)(85182001)(87936001)(92726001)(92566001)(50466002)(95666004)(70736001)(6806004)(76176999)(54356999)(74316001)(50986999)(1496007)(104016003)(106466001)(77096002)(99396003)(53416004)(85202003)(102836001)(110136001)(7059019)(107986001)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB054;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03449D5DD1
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-23 at 12:28PM +0200, Antoine Tenart wrote:
> Add a USB2 ChipIdea driver for ci13xxx, with optional PHY, clock
> and DMA mask, to support USB2 ChipIdea controllers that don't need
> specific functions.
> 
> Tested on the Marvell Berlin SoCs USB controllers.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>

This driver also works for Zynq. I didn't do extensive testing, but I
could access a flash drive successfully.

Tested-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

	Thanks,
	Sören
