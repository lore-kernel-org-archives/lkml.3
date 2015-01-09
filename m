Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbbAITPI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 14:15:08 -0500
Received: from mail-bl2on0053.outbound.protection.outlook.com ([65.55.169.53]:53815
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751224AbbAITPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 14:15:05 -0500
Date: Fri, 9 Jan 2015 13:14:24 -0600
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@linuxheads99
To: Pavel Machek <pavel@denx.de>
CC: <gregkh@linuxfoundation.org>, <jgunthorpe@obsidianresearch.com>,
        <hpa@zytor.com>, <monstr@monstr.eu>, <michal.simek@xilinx.com>,
        <rdunlap@infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <pantelis.antoniou@konsulko.com>,
        <robh+dt@kernel.org>, <grant.likely@linaro.org>,
        <iws@ovro.caltech.edu>, <linux-doc@vger.kernel.org>,
        <broonie@kernel.org>, <philip@balister.org>, <rubini@gnudd.com>,
        <s.trumtrar@pengutronix.de>, <jason@lakedaemon.net>,
        <kyle.teske@ni.com>, <nico@linaro.org>, <balbi@ti.com>,
        <m.chehab@samsung.com>, <davidb@codeaurora.org>, <rob@landley.net>,
        <davem@davemloft.net>, <cesarb@cesarb.net>, <sameo@linux.intel.com>,
        <akpm@linux-foundation.org>, <linus.walleij@linaro.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <devel@driverdev.osuosl.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v8 2/4] fpga manager: add sysfs interface document
In-Reply-To: <20150107084819.GA1887@amd>
Message-ID: <alpine.DEB.2.02.1501091302370.30067@linuxheads99>
References: <1420575219-27061-1-git-send-email-atull@opensource.altera.com> <1420575219-27061-3-git-send-email-atull@opensource.altera.com> <20150107084819.GA1887@amd>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY2PR06CA055.namprd06.prod.outlook.com (10.141.250.173) To
 BN3PR0301MB1234.namprd03.prod.outlook.com (25.161.207.22)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=atull@opensource.altera.com; 
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BN3PR0301MB1234;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN3PR0301MB1234;
X-Forefront-PRVS: 04519BA941
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(164054003)(24454002)(50944004)(51704005)(377424004)(189002)(68736005)(46406003)(50466002)(47776003)(122386002)(87976001)(40100003)(66066001)(33716001)(105586002)(86362001)(54356999)(69596002)(106356001)(50986999)(76176999)(81156004)(19580395003)(19580405001)(83506001)(2950100001)(42186005)(53416004)(97736003)(23726002)(110136001)(101416001)(46102003)(86152002)(62966003)(77156002)(92566002)(7059030);DIR:OUT;SFP:1101;SCL:1;SRVR:BN3PR0301MB1234;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN3PR0301MB1234;
X-OriginatorOrg: opensource.altera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2015 19:14:57.1085 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR0301MB1234
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2015, Pavel Machek wrote:

> On Tue 2015-01-06 14:13:37, atull@opensource.altera.com wrote:
> > +
> > +What:		/sys/class/fpga_manager/<fpga>/firmware
> > +Date:		October 2014
> > +KernelVersion:	3.18
> > +Contact:	Alan Tull <atull@opensource.altera.com>
> > +Description:	Name of the FPGA image file to load using firmware
> > class.
> 
> This one is ugly: it unneccessarily passes firmware name through the
> kernel. Just make interface and code simpler by always passing
> "socfpga-fpga-image" or something like that.
> 
> Thanks,
> 									Pavel

Hi Pavel,

It might be ugly.  It's not unnecessary.  Some uses of FPGAs involve
switching out the FPGA images dynamically under control of the userspace.

Alan
