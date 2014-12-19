Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430AbaLSPzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 10:55:47 -0500
Received: from mail-by2on0061.outbound.protection.outlook.com ([207.46.100.61]:65168
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750953AbaLSPzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 10:55:45 -0500
Date: Fri, 19 Dec 2014 09:55:34 -0600
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@linuxheads99
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: Michal Simek <michal.simek@xilinx.com>, <gregkh@linuxfoundation.org>,
        <jgunthorpe@obsidianresearch.com>, <hpa@zytor.com>, <monstr@monstr.eu>,
        <rdunlap@infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <pantelis.antoniou@konsulko.com>,
        <robh+dt@kernel.org>, <grant.likely@linaro.org>,
        <iws@ovro.caltech.edu>, <linux-doc@vger.kernel.org>, <pavel@denx.de>,
        <broonie@kernel.org>, <philip@balister.org>, <rubini@gnudd.com>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <devel@driverdev.osuosl.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v6 4/4] staging: fpga manager: add driver for socfpga
 fpga manager
In-Reply-To: <20141219150714.GG13070@pengutronix.de>
Message-ID: <alpine.DEB.2.02.1412190955090.16892@linuxheads99>
References: <1418941748-16111-1-git-send-email-atull@opensource.altera.com> <1418941748-16111-5-git-send-email-atull@opensource.altera.com> <20141219085516.GF13070@pengutronix.de> <2d65a072f8c14d1e839307465f177a1a@BY2FFO11FD046.protection.gbl>
 <20141219150714.GG13070@pengutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY1PR00CA0035.namprd00.prod.outlook.com (25.160.102.45) To
 CY1PR0301MB1244.namprd03.prod.outlook.com (25.161.212.154)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=atull@opensource.altera.com; 
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1244;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CY1PR0301MB1244;
X-Forefront-PRVS: 0430FA5CB7
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(24454002)(189002)(54534003)(199003)(51704005)(479174004)(377454003)(93886004)(21056001)(19580395003)(99396003)(62966003)(42186005)(50466002)(110136001)(120916001)(69596002)(97736003)(23726002)(68736005)(105586002)(77156002)(76176999)(101416001)(86152002)(81156004)(54356999)(87976001)(92566001)(46406003)(4396001)(86362001)(107046002)(83506001)(53416004)(20776003)(40100003)(122386002)(31966008)(66066001)(46102003)(15975445007)(50986999)(33716001)(2950100001)(64706001)(19580405001)(106356001)(47776003)(7059030);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR0301MB1244;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1244;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2014, Steffen Trumtrar wrote:

> On Fri, Dec 19, 2014 at 03:05:50PM +0100, Michal Simek wrote:
> > On 12/19/2014 09:55 AM, Steffen Trumtrar wrote:
> > > Hi!
> > > 
> > > Just a minor nitpick, but...
> > > 
> > > On Thu, Dec 18, 2014 at 04:29:08PM -0600, atull@opensource.altera.com wrote:
> > >> From: Alan Tull <atull@opensource.altera.com>
> > >>
> > >> Add driver to fpga manager framework to allow configuration
> > >> of FPGA in Altera SoCFPGA parts.
> > >>
> > >> Signed-off-by: Alan Tull <atull@opensource.altera.com>
> > >> Acked-by: Michal Simek <michal.simek@xilinx.com>
> > >> ---
> > >> v2: fpga_manager struct now contains struct device
> > >>     fpga_manager_register parameters now take device
> > >>
> > >> v3: skip a version to align versions
> > >>
> > >> v4: move to drivers/staging
> > >>
> > >> v5: fix array_size.cocci warnings
> > >>     fix platform_no_drv_owner.cocci warnings
> > >>     Remove .owner = THIS_MODULE
> > >>     include asm/irq.h
> > >>     clean up list of includes
> > >>     use altera_fpga_reset for ops
> > >>     use enum fpga_mgr_states or u32 as needed
> > >>     use devm_request_irq
> > >>     check irq <= 0 instead of == NO_IRQ
> > >>     Use ARRAY_SIZE
> > >>     rename altera -> socfpga
> > >>     static const socfpga_fpga_ops
> > >>     header moved to linux/fpga/ folder
> > >>     remove ifdef'ed code
> > >>     use platform_get_resource and platform_get_irq
> > >>     move .probe and .remove lines adjacent
> > >>     use module_platform_driver
> > >>     use __maybe_unused
> > >>     only need to 'if (IS_ENABLED(CONFIG_REGULATOR))' in one fn
> > >>     fix "unsigned 'mode' is never < 0"
> > >>
> > >> v6: return error for (unused) default of case statement
> > >> ---
> > >   ^^^
> > > 
> > > ...if you remove these, than that changelog will not land in the final
> > > commit which I would prefer. Nobody cares for the changelog of a
> > > patch once it is in its final state. And this is a rather noisy one.
> > > When someone in the future looks at this, he will see two lines of
> > > information and 10 times that of uninteresting noise.
> > > 
> > > Not a dealbreaker, but just something to consider for future patches.
> > 
> > 
> > When you run git-am you will see that changelog is not there.
> > 
> 
> Ah, great. It seems like git-am does indeed know now how to handle this.
> There are some commits in mainline that have this changelog added,
> because there where two '---' lines in the patch.
> 
> Then go on kind sirs with whatever you where doing and don't pay any
> attention to my comment... :-)
> 
> Regards,
> Steffen
> 

git format-patch adds the second ---

Alan

> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
