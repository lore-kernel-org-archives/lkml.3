Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbbAKQI4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 11:08:56 -0500
Received: from mail-bl2on0084.outbound.protection.outlook.com ([65.55.169.84]:51520
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751063AbbAKQIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 11:08:52 -0500
Date: Sun, 11 Jan 2015 10:08:19 -0600
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@shineypoop
To: Konrad Zapalowicz <bergo.torino@gmail.com>
CC: <gregkh@linuxfoundation.org>, <jgunthorpe@obsidianresearch.com>,
        <hpa@zytor.com>, <monstr@monstr.eu>, <michal.simek@xilinx.com>,
        <rdunlap@infradead.org>, <mark.rutland@arm.com>,
        <linux-doc@vger.kernel.org>, <rubini@gnudd.com>,
        <pantelis.antoniou@konsulko.com>, <s.trumtrar@pengutronix.de>,
        <devel@driverdev.osuosl.org>, <sameo@linux.intel.com>,
        <nico@linaro.org>, <ijc+devicetree@hellion.org.uk>,
        <kyle.teske@ni.com>, <grant.likely@linaro.org>,
        <davidb@codeaurora.org>, <linus.walleij@linaro.org>,
        <cesarb@cesarb.net>, <devicetree@vger.kernel.org>,
        <jason@lakedaemon.net>, <pawel.moll@arm.com>, <iws@ovro.caltech.edu>,
        <broonie@kernel.org>, <philip@balister.org>,
        <dinguyen@opensource.altera.com>, <pavel@denx.de>,
        <yvanderv@opensource.altera.com>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <delicious.quinoa@gmail.com>, <robh+dt@kernel.org>,
        <rob@landley.net>, <galak@codeaurora.org>, <akpm@linux-foundation.org>,
        <davem@davemloft.net>, <m.chehab@samsung.com>
Subject: Re: [PATCH v8 0/4] FPGA Manager Framework
In-Reply-To: <20150110181120.GA26067@t400>
Message-ID: <alpine.DEB.2.10.1501111004580.2556@shineypoop>
References: <1420575219-27061-1-git-send-email-atull@opensource.altera.com> <20150110181120.GA26067@t400>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [24.206.110.125]
X-ClientProxiedBy: BLUPR01CA055.prod.exchangelabs.com (25.160.23.45) To
 CY1PR0301MB1241.namprd03.prod.outlook.com (25.161.212.151)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=atull@opensource.altera.com; 
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:CY1PR0301MB1241;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CY1PR0301MB1241;
X-Forefront-PRVS: 045315E1EE
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(24454002)(164054003)(199003)(189002)(51704005)(87976001)(106356001)(122386002)(68736005)(1720100001)(86152002)(40100003)(46406003)(101416001)(2950100001)(110136001)(54356999)(15975445007)(47776003)(76176999)(50986999)(50466002)(64706001)(83506001)(42186005)(66066001)(23726002)(86362001)(46102003)(19580395003)(19580405001)(105586002)(77156002)(97736003)(33716001)(92566002)(7059030);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR0301MB1241;H:shineypoop.local;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1241;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2015 16:08:40.2912 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR0301MB1241
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0618;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jan 2015, Konrad Zapalowicz wrote:

> On 01/06, atull@opensource.altera.com wrote:
> > From: Alan Tull <atull@opensource.altera.com>
> 
> Alan, there is something wrong with your email client configuration
> and you need to fix.
> 
> thanks,
> konrad

Hi Konrad,

Can you be more specific?  What problem are you seeing?  Is it a problem 
with the original patch  post or when I reply?  When I a post, I'm using
'git send-email' with sendmail and when I am replying, I am using alpine.

Alan

>  
> > v8 changes the compatible string for SOCFPGA FPGA managers
> > to be more chip specific.
> > 
> > "altr,fpga-mgr" becomes "altr,socfpga-fpga-mgr"
> > 
> > Thanks,
> > Alan
> > 
> > Alan Tull (4):
> >   doc: add bindings document for altera fpga manager
> >   fpga manager: add sysfs interface document
> >   staging: fpga manager: framework core
> >   staging: fpga manager: add driver for socfpga fpga manager
> > 
> >  drivers/staging/Kconfig                            |    2 +
> >  drivers/staging/Makefile                           |    1 +
> >  .../Documentation/ABI/sysfs-class-fpga-manager     |   38 ++
> >  .../bindings/altera-socfpga-fpga-mgr.txt           |   17 +
> >  drivers/staging/fpga/Kconfig                       |   29 +
> >  drivers/staging/fpga/Makefile                      |    9 +
> >  drivers/staging/fpga/fpga-mgr.c                    |  551 ++++++++++++++++
> >  drivers/staging/fpga/socfpga.c                     |  694 ++++++++++++++++++++
> >  include/linux/fpga/fpga-mgr.h                      |  124 ++++
> >  9 files changed, 1465 insertions(+)
> >  create mode 100644 drivers/staging/fpga/Documentation/ABI/sysfs-class-fpga-manager
> >  create mode 100644 drivers/staging/fpga/Documentation/bindings/altera-socfpga-fpga-mgr.txt
> >  create mode 100644 drivers/staging/fpga/Kconfig
> >  create mode 100644 drivers/staging/fpga/Makefile
> >  create mode 100644 drivers/staging/fpga/fpga-mgr.c
> >  create mode 100644 drivers/staging/fpga/socfpga.c
> >  create mode 100644 include/linux/fpga/fpga-mgr.h
> > 
> > -- 
> > 1.7.9.5
> > 
> > _______________________________________________
> > devel mailing list
> > devel@linuxdriverproject.org
> > http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
> 
