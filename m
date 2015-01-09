Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbbAIS7O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 13:59:14 -0500
Received: from mail-bn1on0093.outbound.protection.outlook.com ([157.56.110.93]:22413
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758085AbbAIS7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 13:59:11 -0500
Date: Fri, 9 Jan 2015 12:58:31 -0600
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@linuxheads99
To: Rob Herring <robherring2@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Simek <monstr@monstr.eu>,
        Michal Simek <michal.simek@xilinx.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>, <iws@ovro.caltech.edu>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>, Mark Brown <broonie@kernel.org>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Kyle Teske <kyle.teske@ni.com>,
        Nicolas Pitre <nico@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        David Brown <davidb@codeaurora.org>, Rob Landley <rob@landley.net>,
        David Miller <davem@davemloft.net>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devel@driverdev.osuosl.org>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        "yvanderv@opensource.altera.com" <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v8 1/4] doc: add bindings document for altera fpga
 manager
In-Reply-To: <CAL_Jsq+pn5MW6veUivEL49FLSQxZOWRq0gU9Q6iD5jzurKK3rQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1501091256150.30067@linuxheads99>
References: <1420575219-27061-1-git-send-email-atull@opensource.altera.com> <1420575219-27061-2-git-send-email-atull@opensource.altera.com> <CAL_JsqKRe2YquSmi01wa5b=Ctns+1ek-PdSHDLuxyCfKasTw5g@mail.gmail.com> <alpine.DEB.2.02.1501061627150.18120@linuxheads99>
 <CAL_Jsq+pn5MW6veUivEL49FLSQxZOWRq0gU9Q6iD5jzurKK3rQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DM2PR10CA0061.namprd10.prod.outlook.com (10.141.241.29) To
 BY1PR0301MB1237.namprd03.prod.outlook.com (25.161.203.21)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=atull@opensource.altera.com; 
X-DmarcAction: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BY1PR0301MB1237;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:(601004);SRVR:BY1PR0301MB1237;
X-Forefront-PRVS: 04519BA941
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(979002)(6009001)(24454002)(377454003)(189002)(199003)(164054003)(51704005)(64706001)(86362001)(87976001)(93886004)(97736003)(47776003)(101416001)(46406003)(69596002)(92566002)(46102003)(19580405001)(33716001)(19580395003)(83506001)(1411001)(42186005)(86152002)(66066001)(53416004)(54356999)(76176999)(50986999)(81156004)(110136001)(23726002)(106356001)(62966003)(122386002)(40100003)(77156002)(105586002)(68736005)(2950100001)(50466002)(7059030)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1237;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:ovrnspm;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1237;
X-OriginatorOrg: opensource.altera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2015 18:59:04.6049 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0301MB1237
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2015, Rob Herring wrote:

> On Tue, Jan 6, 2015 at 4:34 PM, atull <atull@opensource.altera.com> wrote:
> > On Tue, 6 Jan 2015, Rob Herring wrote:
> >
> >> On Tue, Jan 6, 2015 at 2:13 PM,  <atull@opensource.altera.com> wrote:
> >> > From: Alan Tull <atull@opensource.altera.com>
> >> >
> >> > New bindings document for Altera fpga manager.
> >> >
> >> > Signed-off-by: Alan Tull <atull@opensource.altera.com>
> >>
> >> Acked-by: Rob Herring <robh@kernel.org>
> >>
> >> Like I said, this binding doesn't look like it will change other than
> >> perhaps additional optional properties, so it can go into
> >> Documentation. Perhaps .../bindings/fpga/. I'm happy to merge this
> >> thru DT tree if you want.
> >>
> >> Rob
> >
> > Thanks, that would be great.  Yes ../bindings/fpga sounds good.
> >
> > Do you want me to send you a patch with the updated path?
> 
> Yes, please.
> 
> Rob
> 

OK I'll split that patch out and just send it separately to you and the DT 
list.

Alan
