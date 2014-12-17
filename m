Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361AbaLQTmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 14:42:06 -0500
Received: from mail-bn1on0083.outbound.protection.outlook.com ([157.56.110.83]:11328
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751155AbaLQTmE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 14:42:04 -0500
Date: Wed, 17 Dec 2014 13:41:53 -0600
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@linuxheads99
To: Michal Simek <michal.simek@xilinx.com>
CC: Greg KH <gregkh@linuxfoundation.org>, <jgunthorpe@obsidianresearch.com>,
        <hpa@zytor.com>, <monstr@monstr.eu>, <rdunlap@infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <pantelis.antoniou@konsulko.com>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>, <iws@ovro.caltech.edu>,
        <linux-doc@vger.kernel.org>, <pavel@denx.de>, <broonie@kernel.org>,
        <philip@balister.org>, <rubini@gnudd.com>, <s.trumtrar@pengutronix.de>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <devel@driverdev.osuosl.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Insop Song <insop.song@gainspeed.com>
Subject: Re: [PATCH v5 6/6] ARM: socfpga: defconfig: enable fpga manager
In-Reply-To: <88f9ec210ca64436bfadc050ec4e17bf@BN1BFFO11FD042.protection.gbl>
Message-ID: <alpine.DEB.2.02.1412171340580.8877@linuxheads99>
References: <1418835289-15752-1-git-send-email-atull@opensource.altera.com> <1418835289-15752-7-git-send-email-atull@opensource.altera.com> <20141217173216.GA24913@kroah.com> <88f9ec210ca64436bfadc050ec4e17bf@BN1BFFO11FD042.protection.gbl>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR05CA0072.namprd05.prod.outlook.com (10.141.20.42) To
 BN3PR0301MB1234.namprd03.prod.outlook.com (25.161.207.22)
Authentication-Results: xilinx.com; dkim=none (message not signed)
 header.d=none;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1234;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN3PR0301MB1234;
X-Forefront-PRVS: 042857DBB5
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(51704005)(189002)(479174004)(164054003)(199003)(377454003)(24454002)(46102003)(46406003)(64706001)(20776003)(47776003)(87976001)(66066001)(76176999)(99396003)(33716001)(50986999)(54356999)(120916001)(40100003)(31966008)(122386002)(50466002)(86152002)(86362001)(42186005)(92566001)(4396001)(106356001)(68736005)(107046002)(81156004)(2950100001)(23726002)(97736003)(83506001)(19580395003)(19580405001)(69596002)(53416004)(77156002)(62966003)(105586002)(21056001)(101416001)(110136001)(93886004)(7059030);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR0301MB1234;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1234;
X-OriginatorOrg: opensource.altera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2014 19:41:57.5730 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR0301MB1234
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2014, Michal Simek wrote:

> On 12/17/2014 06:32 PM, Greg KH wrote:
> > On Wed, Dec 17, 2014 at 10:54:49AM -0600, atull@opensource.altera.com wrote:
> >> From: Alan Tull <atull@opensource.altera.com>
> >>
> >> Enable FPGA manager for Altera socfpga.
> >>
> >> Signed-off-by: Alan Tull <atull@opensource.altera.com>
> >> ---
> >> v5: s/CONFIG_FPGA_MGR_ALTERA/CONFIG_FPGA_MGR_SOCFPGA/
> >> ---
> >>  arch/arm/configs/socfpga_defconfig |    4 ++++
> >>  1 file changed, 4 insertions(+)
> >>
> >> diff --git a/arch/arm/configs/socfpga_defconfig b/arch/arm/configs/socfpga_defconfig
> >> index a2956c3..f1d6a3b 100644
> >> --- a/arch/arm/configs/socfpga_defconfig
> >> +++ b/arch/arm/configs/socfpga_defconfig
> >> @@ -86,6 +86,10 @@ CONFIG_USB_DWC2=y
> >>  CONFIG_USB_DWC2_HOST=y
> >>  CONFIG_MMC=y
> >>  CONFIG_MMC_DW=y
> >> +CONFIG_STAGING=y
> >> +CONFIG_FPGA=y
> >> +CONFIG_FPGA_MGR_SYSFS=y
> >> +CONFIG_FPGA_MGR_SOCFPGA=y
> >>  CONFIG_EXT2_FS=y
> >>  CONFIG_EXT2_FS_XATTR=y
> >>  CONFIG_EXT2_FS_POSIX_ACL=y
> > 
> > Do defconfigs really matter anymore?
> 
> If they want but anyway simply 5/6 and 6/6 shouldn't be the part of this series
> because they should go through arm-soc tree.
> 
> I will look at other patches tmr.
> 
> Monam, Insop: I think you should join this process because gs_fpgaboot
> should be one backend driver of this interface.
> 
> Thanks,
> Michal
> 

OK, we can drop 5/6 and 6/6 from this series.  I'll handle them 
separately.

Alan
