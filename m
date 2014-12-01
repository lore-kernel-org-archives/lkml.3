Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524AbaLAVvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 16:51:42 -0500
Received: from mail-bn1on0073.outbound.protection.outlook.com ([157.56.110.73]:37632
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752885AbaLAVvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 16:51:41 -0500
Date: Mon, 1 Dec 2014 13:51:26 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>,
        Michal Simek <michal.simek@xilinx.com>, <devicetree@vger.kernel.org>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        <linux-kernel@vger.kernel.org>,
        Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>
Subject: Re: [PATCH] ARM: zynq: DT: Add USB to device tree
References: <1417459352-23401-1-git-send-email-soren.brinkmann@xilinx.com>
 <7088901.UGmPabvHQ0@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7088901.UGmPabvHQ0@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21144.002
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <71b9e172438946a5ba74efb430d1418c@BN1AFFO11FD060.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(164054003)(377424004)(24454002)(189002)(199003)(51704005)(64706001)(47776003)(108616004)(106466001)(31966008)(95666004)(19580405001)(92566001)(4396001)(120916001)(76176999)(77096004)(102836001)(23676002)(86362001)(110136001)(54356999)(99396003)(104016003)(62966003)(74316001)(6806004)(77156002)(46102003)(21056001)(107046002)(53416004)(33646002)(50986999)(20776003)(83506001)(44976005)(85202003)(85182001)(87936001)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB024;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB024;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB024;
X-Forefront-PRVS: 0412A98A59
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB024;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Mon, 2014-12-01 at 10:26PM +0100, Arnd Bergmann wrote:
> On Monday 01 December 2014 10:42:32 Soren Brinkmann wrote:
> > +       usb_phy0: usb-phy@0 {
> > +               compatible = "usb-nop-xceiv";
> > +               #phy-cells = <0>;
> > +       };
> >  };
> 
> As discussed in an unrelated thread today, please drop the "@0" in the
> node name, since the device has no 'reg' property.

What is the best practice for naming such nodes then? On these boards
it's not the case, but Zynq has two USB cores. So, there may be DTs that
will have two phys in there. Would we just do 'usb-phy-0'?

	Thanks,
	Sören
