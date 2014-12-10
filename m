Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488AbaLJRSD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 12:18:03 -0500
Received: from mail-bn1bon0079.outbound.protection.outlook.com ([157.56.111.79]:7424
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932247AbaLJRSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 12:18:00 -0500
Date: Wed, 10 Dec 2014 11:17:58 -0600
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@linuxheads99
To: Michal Simek <michal.simek@xilinx.com>
CC: <gregkh@linuxfoundation.org>, <jgunthorpe@obsidianresearch.com>,
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
        <galak@codeaurora.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v4 3/6] ARM: socfpga: defconfig: enable fpga manager
In-Reply-To: <cec3b3d65e864b39899f3cbf17a09dc2@BN1BFFO11FD035.protection.gbl>
Message-ID: <alpine.DEB.2.02.1412101117060.25868@linuxheads99>
References: <1418156090-23578-1-git-send-email-atull@opensource.altera.com> <1418156090-23578-4-git-send-email-atull@opensource.altera.com> <cec3b3d65e864b39899f3cbf17a09dc2@BN1BFFO11FD035.protection.gbl>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR05CA0056.namprd05.prod.outlook.com (10.141.20.26) To
 DM2PR0301MB1246.namprd03.prod.outlook.com (25.160.219.23)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1246;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:DM2PR0301MB1246;
X-Forefront-PRVS: 0421BF7135
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(164054003)(51914003)(24454002)(51704005)(377454003)(479174003)(199003)(83506001)(46406003)(33716001)(19580395003)(19580405001)(31966008)(87976001)(69596002)(97736003)(106356001)(66066001)(86152002)(92566001)(68736005)(21056001)(107046002)(40100003)(81156004)(105586002)(86362001)(122386002)(77156002)(62966003)(99396003)(110136001)(120916001)(46102003)(101416001)(4396001)(23726002)(76176999)(54356999)(64706001)(50986999)(53416004)(42186005)(50466002)(20776003)(47776003)(7059030);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR0301MB1246;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB1246;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2014, Michal Simek wrote:

> Hi Alan,
> 
> On 12/09/2014 09:14 PM, atull@opensource.altera.com wrote:
> > From: Alan Tull <atull@opensource.altera.com>
> > 
> > Enable FPGA manager for Altera socfpga.
> > 
> > Signed-off-by: Alan Tull <atull@opensource.altera.com>
> > ---
> >  arch/arm/configs/socfpga_defconfig |    4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/arch/arm/configs/socfpga_defconfig b/arch/arm/configs/socfpga_defconfig
> > index a2956c3..2740057 100644
> > --- a/arch/arm/configs/socfpga_defconfig
> > +++ b/arch/arm/configs/socfpga_defconfig
> > @@ -86,6 +86,10 @@ CONFIG_USB_DWC2=y
> >  CONFIG_USB_DWC2_HOST=y
> >  CONFIG_MMC=y
> >  CONFIG_MMC_DW=y
> > +CONFIG_STAGING=y
> > +CONFIG_FPGA=y
> > +CONFIG_FPGA_MGR_SYSFS=y
> > +CONFIG_FPGA_MGR_ALTERA=y
> >  CONFIG_EXT2_FS=y
> >  CONFIG_EXT2_FS_XATTR=y
> >  CONFIG_EXT2_FS_POSIX_ACL=y
> > 
> 
> This should the last patch in this series because you are changing Kconfig
> in 5/6 and 6/6.
> 
> Thanks,
> Michal
> 

OK, I'm fixing this in v5, also taking your other comments.  Thanks for 
the review.

Alan

