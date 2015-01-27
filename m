Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759859AbbA0VOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:14:08 -0500
Received: from mail-bn1on0069.outbound.protection.outlook.com ([157.56.110.69]:22016
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753450AbbA0VOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:14:05 -0500
Date: Tue, 27 Jan 2015 13:14:00 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
CC: Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        "balbi@ti.com" <balbi@ti.com>,
        "Dinh Nguyen (dinguyen@opensource.altera.com)" 
	<dinguyen@opensource.altera.com>,
        "lyz@rock-chips.com" <lyz@rock-chips.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: phy: make GPIOs optional for the generic phy
References: <A2CA0424C0A6F04399FB9E1CD98E0304845078CE@US01WEMBX2.internal.synopsys.com>
 <878uh3x9j4.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <878uh3x9j4.fsf@free.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21288.002
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <b6e4f765d9514a94ac93a4057ed735f6@BL2FFO11FD054.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; vger.kernel.org; dkim=none (message
 not signed) header.d=none;
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(24454002)(377424004)(51704005)(92726002)(62966003)(110136001)(76176999)(23676002)(77156002)(92566002)(50466002)(54356999)(50986999)(46102003)(85202003)(108616004)(74316001)(53416004)(85182001)(86362001)(19580405001)(6806004)(575784001)(104016003)(47776003)(2950100001)(87936001)(83506001)(106466001)(19580395003)(15866825004)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB019;H:xsj-pvapsmtpgw01;FPR:;SPF:None;MLV:sfv;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB019;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BL2FFO11HUB019;
X-Forefront-PRVS: 046985391D
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB019;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2015 21:14:03.1942
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL2FFO11HUB019
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-16 at 12:14PM +0100, Robert Jarzmik wrote:
> Paul Zimmerman <Paul.Zimmerman@synopsys.com> writes:
> 
> > From 47bd18e210fecf701d493c27884e13c69bc449ea Mon Sep 17 00:00:00 2001
> > From: Paul Zimmerman <paulz@synopsys.com>
> > Date: Wed, 14 Jan 2015 18:15:58 -0800
> > Subject: [PATCH] usb: phy: make GPIOs optional for the generic phy
> >
> > The use of GPIOs should be optional for the generic phy, otherwise
> > the Altera SOCFPGA platform at least is broken.
> >
> > Fixes breakage caused by a combination of e9f2cefb0cd "usb: phy: 
> > generic: migrate to gpio_desc" and 135b3c4304d "usb: dwc2: platform: 
> > add generic PHY framework support".
> >
> > Signed-off-by: Paul Zimmerman <paulz@synopsys.com>
> Reviewed-by: Robert Jarzmik <robert.jarzmik@free.fr>
Tested-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

Zynq suffers of the same problem.

	Sören
