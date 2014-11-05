Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755734AbaKERKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:10:47 -0500
Received: from mail-bn1on0061.outbound.protection.outlook.com ([157.56.110.61]:22641
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755704AbaKERKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:10:43 -0500
Date: Wed, 5 Nov 2014 09:10:30 -0800
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
 <54599853.9050706@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54599853.9050706@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21076.007
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <20d5a924832b4a91819fdbecc33b11b6@BL2FFO11FD006.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(164054003)(199003)(24454002)(377424004)(189002)(51704005)(64706001)(6806004)(31966008)(110136001)(102836001)(53416004)(107046002)(44976005)(92566001)(21056001)(20776003)(4396001)(95666004)(86362001)(106466001)(47776003)(85202003)(83506001)(85182001)(50986999)(23676002)(76176999)(87936001)(54356999)(77096003)(46102003)(50466002)(104016003)(120916001)(77156002)(74316001)(62966003)(108616004)(99396003)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB062;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB062;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0386B406AA
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-05 at 04:24AM +0100, Andreas Färber wrote:
> Hi,
> 
> Am 03.11.2014 um 20:05 schrieb Soren Brinkmann:
> > +	PINCTRL_PIN(54, "EMIO_SD0_WP"),
> > +	PINCTRL_PIN(55, "EMIO_SD0_CD"),
> > +	PINCTRL_PIN(56, "EMIO_SD1_WP"),
> > +	PINCTRL_PIN(57, "EMIO_SD0_CD"),
> 
> Should this be "EMIO_SD1_CD"?

Absolutely, good catch.

	Thanks,
	Sören
