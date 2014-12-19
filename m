Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaLSOVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:21:24 -0500
Received: from mail-bn1bon0059.outbound.protection.outlook.com ([157.56.111.59]:45925
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752077AbaLSOVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:21:23 -0500
Date: Fri, 19 Dec 2014 15:20:59 +0100
From: Michal Simek <michal.simek@xilinx.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: <atull@opensource.altera.com>, <gregkh@linuxfoundation.org>,
        <jgunthorpe@obsidianresearch.com>, <hpa@zytor.com>, <monstr@monstr.eu>,
        <michal.simek@xilinx.com>, <rdunlap@infradead.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
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
Subject: Re: [PATCH v6 0/4] FPGA Manager Framework
References: <1418941748-16111-1-git-send-email-atull@opensource.altera.com>
In-Reply-To: <1418941748-16111-1-git-send-email-atull@opensource.altera.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21186.006
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <5901b1791e1c4b09b72cb22c5eca68ca@BL2FFO11FD047.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 62.221.5.235)
 smtp.mailfrom=michal.simek@xilinx.com; 
X-Forefront-Antispam-Report: CIP:62.221.5.235;CTRY:GB;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(479174004)(377454003)(199003)(51704005)(189002)(164054003)(24454002)(92726002)(50986999)(64706001)(54356999)(77096005)(108616004)(46102003)(31966008)(76176999)(20776003)(107046002)(62966003)(2950100001)(106466001)(77156002)(47776003)(64126003)(50466002)(65956001)(65806001)(74316001)(6806004)(19580405001)(87936001)(19580395003)(4396001)(120916001)(99396003)(86362001)(104016003)(2201001)(83506001)(23746002)(92566001)(21056001)(65826006)(107986001)(24736002)(2101003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB018;H:xir-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-62-221-5-235.ipspace.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB018;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BL2FFO11HUB018;
X-Forefront-PRVS: 0430FA5CB7
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB018;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 12/18/2014 11:29 PM, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
> 
> Dropping the changes to socfpga DTS and defconfig from this
> patch set.
> 
> Kernel doc fixes and other minor fixes as listed in the patches.
> 
> Alan
> 
> Alan Tull (4):
>   doc: add bindings document for altera fpga manager
>   fpga manager: add sysfs interface document
>   staging: fpga manager: framework core
>   staging: fpga manager: add driver for socfpga fpga manager
> 
>  drivers/staging/Kconfig                            |    2 +
>  drivers/staging/Makefile                           |    1 +
>  .../Documentation/ABI/sysfs-class-fpga-manager     |   38 ++
>  .../Documentation/bindings/altera-fpga-mgr.txt     |   17 +
>  drivers/staging/fpga/Kconfig                       |   29 +
>  drivers/staging/fpga/Makefile                      |    9 +
>  drivers/staging/fpga/fpga-mgr.c                    |  551 ++++++++++++++++
>  drivers/staging/fpga/socfpga.c                     |  694 ++++++++++++++++++++
>  include/linux/fpga/fpga-mgr.h                      |  124 ++++
>  9 files changed, 1465 insertions(+)
>  create mode 100644 drivers/staging/fpga/Documentation/ABI/sysfs-class-fpga-manager
>  create mode 100644 drivers/staging/fpga/Documentation/bindings/altera-fpga-mgr.txt
>  create mode 100644 drivers/staging/fpga/Kconfig
>  create mode 100644 drivers/staging/fpga/Makefile
>  create mode 100644 drivers/staging/fpga/fpga-mgr.c
>  create mode 100644 drivers/staging/fpga/socfpga.c
>  create mode 100644 include/linux/fpga/fpga-mgr.h
> 

I think we have reasonable number of patches which can go to the staging
and we can work on it and extend it. I have xilinx zynq driver in my repository too.
Also I would try to integrate staging/gs_fpgaboot/ because they do just the same
thing. Also char/xilinx_hwicap should be added to this subfolder (and clean a lot).
I am not aware about any other fpga driver in the tree but I didn't grep it
(IRC xillybus targets a little bit different thing). Please let me know if you are
aware about different one.

I was talking to Altera guys at ELCE and conclusion was that will be the best to
maintain future drivers/fpga/ together.
It means if there is no problem with this series. Do you want me to add these
patches to any repository at kernel.org and send you pull request?
Or you just prefer to take these patches directly to staging and we will use
separate repository later?
We will also create fragment to MAINTAINERS file to reflect this.

Thanks,
Michal
