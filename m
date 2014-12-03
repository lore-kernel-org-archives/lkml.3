Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbaLCR75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 12:59:57 -0500
Received: from mail-by2on0071.outbound.protection.outlook.com ([207.46.100.71]:33096
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750730AbaLCR7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 12:59:55 -0500
Date: Wed, 3 Dec 2014 09:59:50 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Alessandro Rubini <rubini@unipv.it>, Heiko Stuebner <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        <linux-rockchip@lists.infradead.org>, <linux-sh@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Beniamino Galvani <b.galvani@gmail.com>
Subject: Re: [PATCH v2 0/7] Pinctrl support for Zynq
References: <1417137993-8337-1-git-send-email-soren.brinkmann@xilinx.com>
 <1417611103.30615.25.camel@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417611103.30615.25.camel@mm-sol.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21148.001
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <d1b90be2a67942e8a058e27b4cd38e66@BY2FFO11FD036.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(53754006)(51704005)(377424004)(24454002)(189002)(164054003)(199003)(15975445006)(21056001)(85202003)(77156002)(108616004)(31966008)(107046002)(64706001)(104016003)(53416004)(85182001)(6806004)(110136001)(46102003)(99396003)(120916001)(54356999)(47776003)(102836001)(74316001)(87936001)(20776003)(92566001)(4396001)(44976005)(86362001)(19580395003)(106466001)(50986999)(23676002)(50466002)(95666004)(83506001)(62966003)(76176999)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB062;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB062;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB062;
X-Forefront-PRVS: 0414DF926F
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB062;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-03 at 02:51PM +0200, Ivan T. Ivanov wrote:
> 
> On Thu, 2014-11-27 at 17:26 -0800, Soren Brinkmann wrote:
> > Hi all,
> > 
> > here is v2 of this series. 
> 
> Which tree did you use as a base for these patches?
> Tried with pinctrl/devel and linus/master didn't apply.

It's supposed to be pinctrl/devel. And that seems to be mostly true. I
just saw there are two rockchip patches in my branch which shouldn't be.
Guess some rebase went wrong (or the devel branch was rewritten?).
I pushed the series here:
https://github.com/sorenb-xlnx/linux-xlnx/commits/pinctrl

	Thanks,
	Sören
