Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaJ0RuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:50:08 -0400
Received: from mail-bl2on0090.outbound.protection.outlook.com ([65.55.169.90]:28826
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750958AbaJ0RuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:50:06 -0400
Date: Mon, 27 Oct 2014 10:49:50 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
CC: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] MAINTAINERS: Add myself as reviewer for Zynq
References: <1414081762-28886-1-git-send-email-soren.brinkmann@xilinx.com>
 <93a573b450ca429cad3ba42f875880d7@BL2FFO11FD051.protection.gbl>
 <1905062.WThGHQej1A@wuerfel>
 <2e0177fec3e14239ba979cbc5e924a73@BN1BFFO11FD026.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2e0177fec3e14239ba979cbc5e924a73@BN1BFFO11FD026.protection.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21056.005
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <f506a31d4f3b47f7aa3d08cc653a0de5@BY2FFO11FD041.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(41574002)(199003)(377454003)(479174003)(377424004)(24454002)(51704005)(189002)(64706001)(50986999)(54356999)(50466002)(74316001)(31966008)(76482002)(76176999)(20776003)(53416004)(16601075003)(19580395003)(19580405001)(4396001)(102836001)(95666004)(15202345003)(106466001)(47776003)(80022003)(44976005)(23676002)(587094004)(99396003)(15975445006)(85852003)(92566001)(83506001)(86362001)(85182001)(87936001)(120916001)(21056001)(85202003)(46102003)(77096002)(6806004)(85306004)(104016003)(107046002)(110136001)(93886004)(108616004)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2FFO11HUB039;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2FFO11HUB039;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Forefront-PRVS: 0377802854
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-24 at 10:45AM +0200, Michal Simek wrote:
> On 10/24/2014 10:30 AM, Arnd Bergmann wrote:
> > On Friday 24 October 2014 08:08:15 Michal Simek wrote:
> >> On 10/23/2014 06:29 PM, Soren Brinkmann wrote:
> >>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> >>> ---
> >>> v2:
> >>>  - I removed the additional 'F' entries
> >>>
> >>>  MAINTAINERS | 1 +
> >>>  1 file changed, 1 insertion(+)
> >>>
> >>> diff --git a/MAINTAINERS b/MAINTAINERS
> >>> index 0484f2c526f0..8b49eeee5a27 100644
> >>> --- a/MAINTAINERS
> >>> +++ b/MAINTAINERS
> >>> @@ -1543,6 +1543,7 @@ F:      arch/arm/mach-pxa/include/mach/z2.h
> >>>  
> >>>  ARM/ZYNQ ARCHITECTURE
> >>>  M:   Michal Simek <michal.simek@xilinx.com>
> >>> +R:   Sören Brinkmann <soren.brinkmann@xilinx.com>
> >>>  L:   linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> >>>  W:   http://wiki.xilinx.com
> >>>  T:   git git://git.xilinx.com/linux-xlnx.git
> >>>
> >>
> >> Applied.
> >> IMHO: This can go through arm-soc tree.
> > 
> > Yes, a simple patch like this, you can forward to use with your
> > Signed-off-by, or add an Ack and ask us to pick it up directly.
> > 
> > With the current timing, I can still pick it up as a fix for 3.18 if you
> > like.
> > 
> 
> Ok here is my
> Acked-by: Michal Simek <michal.simek@xilinx.com>
> 
> and please pick it up as fix directly to 3.18.

Thanks!

	Sören
