Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaLSPro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 10:47:44 -0500
Received: from mail-bn1bon0055.outbound.protection.outlook.com ([157.56.111.55]:55917
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750953AbaLSPrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 10:47:42 -0500
Date: Fri, 19 Dec 2014 09:47:26 -0600
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@linuxheads99
To: Greg KH <gregkh@linuxfoundation.org>
CC: Michal Simek <michal.simek@xilinx.com>, <jgunthorpe@obsidianresearch.com>,
        <hpa@zytor.com>, <monstr@monstr.eu>, <rdunlap@infradead.org>,
        <mark.rutland@arm.com>, <linux-doc@vger.kernel.org>,
        <rubini@gnudd.com>, <pantelis.antoniou@konsulko.com>,
        <s.trumtrar@pengutronix.de>, <devel@driverdev.osuosl.org>,
        <sameo@linux.intel.com>, <nico@linaro.org>,
        <ijc+devicetree@hellion.org.uk>, <kyle.teske@ni.com>,
        <grant.likely@linaro.org>, <davidb@codeaurora.org>,
        <linus.walleij@linaro.org>, <cesarb@cesarb.net>,
        <devicetree@vger.kernel.org>, <jason@lakedaemon.net>,
        <pawel.moll@arm.com>, <iws@ovro.caltech.edu>, <broonie@kernel.org>,
        <philip@balister.org>, <dinguyen@opensource.altera.com>,
        <pavel@denx.de>, <yvanderv@opensource.altera.com>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>,
        <delicious.quinoa@gmail.com>, <robh+dt@kernel.org>, <rob@landley.net>,
        <galak@codeaurora.org>, <akpm@linux-foundation.org>,
        <davem@davemloft.net>, <m.chehab@samsung.com>
Subject: Re: [PATCH v6 0/4] FPGA Manager Framework
In-Reply-To: <20141219153828.GA19077@kroah.com>
Message-ID: <alpine.DEB.2.02.1412190945490.16892@linuxheads99>
References: <1418941748-16111-1-git-send-email-atull@opensource.altera.com> <5901b1791e1c4b09b72cb22c5eca68ca@BL2FFO11FD047.protection.gbl> <20141219153828.GA19077@kroah.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR08CA0050.namprd08.prod.outlook.com (10.242.217.178) To
 BY1PR0301MB1238.namprd03.prod.outlook.com (25.161.203.22)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=atull@opensource.altera.com; 
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1238;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY1PR0301MB1238;
X-Forefront-PRVS: 0430FA5CB7
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(24454002)(51704005)(377454003)(199003)(479174004)(19580405001)(23726002)(2950100001)(110136001)(87976001)(47776003)(20776003)(64706001)(66066001)(53416004)(50466002)(4396001)(46406003)(42186005)(81156004)(107046002)(105586002)(33716001)(15975445007)(76176999)(68736005)(97736003)(31966008)(46102003)(120916001)(101416001)(86362001)(21056001)(19580395003)(83506001)(62966003)(54356999)(77156002)(40100003)(69596002)(106356001)(50986999)(99396003)(86152002)(122386002)(92566001)(7059030);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1238;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1238;
X-OriginatorOrg: opensource.altera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2014 15:47:32.3717 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0301MB1238
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2014, Greg KH wrote:

> On Fri, Dec 19, 2014 at 03:20:59PM +0100, Michal Simek wrote:
> > Hi Greg,
> > 
> > On 12/18/2014 11:29 PM, atull@opensource.altera.com wrote:
> > > From: Alan Tull <atull@opensource.altera.com>
> > > 
> > > Dropping the changes to socfpga DTS and defconfig from this
> > > patch set.
> > > 
> > > Kernel doc fixes and other minor fixes as listed in the patches.
> > > 
> > > Alan
> > > 
> > > Alan Tull (4):
> > >   doc: add bindings document for altera fpga manager
> > >   fpga manager: add sysfs interface document
> > >   staging: fpga manager: framework core
> > >   staging: fpga manager: add driver for socfpga fpga manager
> > > 
> > >  drivers/staging/Kconfig                            |    2 +
> > >  drivers/staging/Makefile                           |    1 +
> > >  .../Documentation/ABI/sysfs-class-fpga-manager     |   38 ++
> > >  .../Documentation/bindings/altera-fpga-mgr.txt     |   17 +
> > >  drivers/staging/fpga/Kconfig                       |   29 +
> > >  drivers/staging/fpga/Makefile                      |    9 +
> > >  drivers/staging/fpga/fpga-mgr.c                    |  551 ++++++++++++++++
> > >  drivers/staging/fpga/socfpga.c                     |  694 ++++++++++++++++++++
> > >  include/linux/fpga/fpga-mgr.h                      |  124 ++++
> > >  9 files changed, 1465 insertions(+)
> > >  create mode 100644 drivers/staging/fpga/Documentation/ABI/sysfs-class-fpga-manager
> > >  create mode 100644 drivers/staging/fpga/Documentation/bindings/altera-fpga-mgr.txt
> > >  create mode 100644 drivers/staging/fpga/Kconfig
> > >  create mode 100644 drivers/staging/fpga/Makefile
> > >  create mode 100644 drivers/staging/fpga/fpga-mgr.c
> > >  create mode 100644 drivers/staging/fpga/socfpga.c
> > >  create mode 100644 include/linux/fpga/fpga-mgr.h
> > > 
> > 
> > I think we have reasonable number of patches which can go to the staging
> > and we can work on it and extend it. I have xilinx zynq driver in my repository too.
> > Also I would try to integrate staging/gs_fpgaboot/ because they do just the same
> > thing. Also char/xilinx_hwicap should be added to this subfolder (and clean a lot).
> > I am not aware about any other fpga driver in the tree but I didn't grep it
> > (IRC xillybus targets a little bit different thing). Please let me know if you are
> > aware about different one.
> > 
> > I was talking to Altera guys at ELCE and conclusion was that will be the best to
> > maintain future drivers/fpga/ together.
> > It means if there is no problem with this series. Do you want me to add these
> > patches to any repository at kernel.org and send you pull request?
> > Or you just prefer to take these patches directly to staging and we will use
> > separate repository later?
> 
> We don't need a whole new repo just for a single driver or a few new
> files, I'll take these after the new year (can't do anything until
> 3.19-rc1 is out, and then it is vacation time.)
> 
> So I'll just take them from patches, no need for a git tree at all.
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hi Greg,

Thanks.  There is a one line change that the kbuild test robot has
pointed out.  I can post v7 with just that change and let that be it.

Alan

