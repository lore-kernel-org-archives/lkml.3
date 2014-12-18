Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361AbaLRUqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 15:46:30 -0500
Received: from mail-bn1bon0066.outbound.protection.outlook.com ([157.56.111.66]:57888
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751125AbaLRUq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 15:46:28 -0500
Date: Thu, 18 Dec 2014 14:46:15 -0600
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
        <galak@codeaurora.org>, <devel@driverdev.osuosl.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v5 3/6] staging: fpga manager: framework core
In-Reply-To: <05395a89d783481b8b7c06bb299b53e0@BL2FFO11FD020.protection.gbl>
Message-ID: <alpine.DEB.2.02.1412181440490.25208@linuxheads99>
References: <1418835289-15752-1-git-send-email-atull@opensource.altera.com> <1418835289-15752-4-git-send-email-atull@opensource.altera.com> <05395a89d783481b8b7c06bb299b53e0@BL2FFO11FD020.protection.gbl>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY2PR06CA027.namprd06.prod.outlook.com (10.141.250.145) To
 BY1PR0301MB1237.namprd03.prod.outlook.com (25.161.203.21)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=atull@opensource.altera.com; 
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1237;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY1PR0301MB1237;
X-Forefront-PRVS: 042957ACD7
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(24454002)(199003)(51704005)(164054003)(40100003)(50986999)(54356999)(76176999)(68736005)(101416001)(20776003)(64706001)(66066001)(122386002)(47776003)(46102003)(46406003)(2950100001)(50466002)(110136001)(107046002)(33716001)(97736003)(21056001)(23726002)(81156004)(106356001)(69596002)(99396003)(31966008)(83506001)(86152002)(77156002)(62966003)(42186005)(105586002)(120916001)(53416004)(87976001)(92566001)(86362001)(4396001)(7059030);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1237;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1237;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2014 20:46:19.6764 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0301MB1237
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB0901;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2014, Michal Simek wrote:

> Hi Alan,
> 
> first of all - there are these kernel-doc warnings.
> 
> Info(drivers/staging/fpga/fpga-mgr.c:37): Scanning doc for fpga_mgr_low_level_state
> Warning(drivers/staging/fpga/fpga-mgr.c:43): No description found for return value of 'fpga_mgr_low_level_state'
> Info(drivers/staging/fpga/fpga-mgr.c:51): Scanning doc for __fpga_mgr_reset
> Warning(drivers/staging/fpga/fpga-mgr.c:55): No description found for return value of '__fpga_mgr_reset'
> Info(drivers/staging/fpga/fpga-mgr.c:69): Scanning doc for fpga_mgr_reset
> Warning(drivers/staging/fpga/fpga-mgr.c:73): No description found for return value of 'fpga_mgr_reset'
> Info(drivers/staging/fpga/fpga-mgr.c:88): Scanning doc for __fpga_mgr_stage_init
> Warning(drivers/staging/fpga/fpga-mgr.c:92): No description found for return value of '__fpga_mgr_stage_write_init'
> Info(drivers/staging/fpga/fpga-mgr.c:108): Scanning doc for __fpga_mgr_stage_write
> Warning(drivers/staging/fpga/fpga-mgr.c:115): No description found for return value of '__fpga_mgr_stage_write'
> Info(drivers/staging/fpga/fpga-mgr.c:129): Scanning doc for __fpga_mgr_stage_complete
> Warning(drivers/staging/fpga/fpga-mgr.c:133): No description found for return value of '__fpga_mgr_stage_write_complete'
> Info(drivers/staging/fpga/fpga-mgr.c:151): Scanning doc for __fpga_mgr_write
> Warning(drivers/staging/fpga/fpga-mgr.c:158): No description found for return value of '__fpga_mgr_write'
> Info(drivers/staging/fpga/fpga-mgr.c:173): Scanning doc for fpga_mgr_write
> Warning(drivers/staging/fpga/fpga-mgr.c:179): No description found for return value of 'fpga_mgr_write'
> Info(drivers/staging/fpga/fpga-mgr.c:195): Scanning doc for fpga_mgr_firmware_write
> Warning(drivers/staging/fpga/fpga-mgr.c:204): No description found for return value of 'fpga_mgr_firmware_write'
> Info(drivers/staging/fpga/fpga-mgr.c:234): Scanning doc for fpga_mgr_name
> Warning(drivers/staging/fpga/fpga-mgr.c:239): No description found for return value of 'fpga_mgr_name'
> Info(drivers/staging/fpga/fpga-mgr.c:414): Scanning doc for fpga_mgr_register
> Warning(drivers/staging/fpga/fpga-mgr.c:423): No description found for return value of 'fpga_mgr_register'
> Info(drivers/staging/fpga/fpga-mgr.c:480): Scanning doc for fpga_mgr_remove
> Warning(drivers/staging/fpga/fpga-mgr.c:484): No description found for parameter 'pdev'
> Warning(drivers/staging/fpga/fpga-mgr.c:484): Excess function parameter 'dev' description in 'fpga_mgr_remove'
> 

I see the warnings now.  I wasn't using the '-v' option for kernel-doc.
Fixed in v6.

> > diff --git a/drivers/staging/fpga/Makefile b/drivers/staging/fpga/Makefile
> > new file mode 100644
> > index 0000000..ff6c677
> > --- /dev/null
> > +++ b/drivers/staging/fpga/Makefile
> > @@ -0,0 +1,10 @@
> > +#
> > +# Makefile for the fpga framework and fpga manager drivers.
> > +#
> > +
> > +fpga-mgr-core-y += fpga-mgr.o
> 
> remove this line - it is unused.
> 

OK

> > +static int __init fpga_mgr_dev_init(void)
> > +{
> > +	pr_info("FPGA Manager framework driver\n");
> > +
> > +	fpga_mgr_class = class_create(THIS_MODULE, "fpga_manager");
> > +	if (IS_ERR(fpga_mgr_class))
> > +		return PTR_ERR(fpga_mgr_class);
> > +
> > +	fpga_mgr_class->dev_groups = fpga_mgr_groups;
> 
> 
> Write this here.
>        if (IS_ENABLED(CONFIG_FPGA_MGR_SYSFS)) {
>              fpga_mgr_class->dev_groups = fpga_mgr_groups;
>        }
> 
> I have tested it and it is working just fine. You can compile this
> driver with SYSFS=n
> The whole code is built and config option just export it.
> I think it is better than having #if there.
> 
> Greg: Is there any problem with this solution?
> 

I'm cool with this myself.  I'll add in v6.

> BTW: I have pushed my branch to zero day testing system to get better coverage
> 

Michal, I've already done that with each submission.  Assuming you are
referring to the kbuild test robot.

Alan

> Thanks,
> Michal
> 
> 
> 
