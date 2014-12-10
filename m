Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936AbaLJRXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 12:23:07 -0500
Received: from mail-bl2on0094.outbound.protection.outlook.com ([65.55.169.94]:10708
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756452AbaLJRXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 12:23:04 -0500
Date: Wed, 10 Dec 2014 11:23:02 -0600
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
        <galak@codeaurora.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v4 4/6] fpga manager: add sysfs interface document
In-Reply-To: <4efe5243e781496082b814f7ccdd1b43@BN1BFFO11FD038.protection.gbl>
Message-ID: <alpine.DEB.2.02.1412101122440.25868@linuxheads99>
References: <1418156090-23578-1-git-send-email-atull@opensource.altera.com> <1418156090-23578-5-git-send-email-atull@opensource.altera.com> <c234f48c2ff145b4810cef72482bb49c@BL2FFO11FD045.protection.gbl> <20141210144724.GA17184@kroah.com>
 <4efe5243e781496082b814f7ccdd1b43@BN1BFFO11FD038.protection.gbl>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DM2PR10CA0064.namprd10.prod.outlook.com (10.141.241.32) To
 CY1PR0301MB1241.namprd03.prod.outlook.com (25.161.212.151)
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1241;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(602002);SRVR:CY1PR0301MB1241;
X-Forefront-PRVS: 0421BF7135
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(377454003)(479174003)(24454002)(189002)(164054003)(199003)(51704005)(50986999)(76176999)(54356999)(68736005)(66066001)(97736003)(40100003)(64706001)(47776003)(20776003)(86362001)(86152002)(62966003)(77156002)(122386002)(92566001)(31966008)(101416001)(23726002)(4396001)(87976001)(33716001)(99396003)(81156004)(106356001)(50466002)(120916001)(105586002)(69596002)(107046002)(19580405001)(46406003)(19580395003)(53416004)(21056001)(42186005)(83506001)(110136001)(93886004)(46102003)(7059030);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR0301MB1241;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1241;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1179;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2014, Michal Simek wrote:

> On 12/10/2014 03:47 PM, Greg KH wrote:
> > On Wed, Dec 10, 2014 at 10:42:39AM +0100, Michal Simek wrote:
> >> Hi Greg,
> >>
> >> On 12/09/2014 09:14 PM, atull@opensource.altera.com wrote:
> >>> From: Alan Tull <atull@opensource.altera.com>
> >>>
> >>> Add documentation for new fpga manager sysfs interface.
> >>>
> >>> Signed-off-by: Alan Tull <atull@opensource.altera.com>
> >>> ---
> >>>  Documentation/ABI/testing/sysfs-class-fpga-manager |   38 ++++++++++++++++++++
> >>>  1 file changed, 38 insertions(+)
> >>>  create mode 100644 Documentation/ABI/testing/sysfs-class-fpga-manager
> >>
> >> What's the rule for adding sysfs doc for driver which is added to staging?
> >> Is this location fine?
> > 
> > No, staging drivers should be "self-contained" so when^Wif we delete
> > them, it is easy to do so :)
> > 
> > Put it in the same directory as your driver.
> 
> That's what I thought.
> Thanks for confirmation.
> 
> Thanks,
> Michal
> 
> 

OK I've got that in v5 also.

Alan

