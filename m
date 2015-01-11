Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbbAKQ33 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 11:29:29 -0500
Received: from mail-by2on0072.outbound.protection.outlook.com ([207.46.100.72]:59904
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751214AbbAKQ31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 11:29:27 -0500
Date: Sun, 11 Jan 2015 10:29:00 -0600
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@shineypoop
To: Pavel Machek <pavel@denx.de>
CC: Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <jgunthorpe@obsidianresearch.com>, <hpa@zytor.com>,
        Michal Simek <monstr@monstr.eu>,
        Michal Simek <michal.simek@xilinx.com>, <rdunlap@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>, <iws@ovro.caltech.edu>,
        <linux-doc@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        <philip@balister.org>, <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>, <jason@lakedaemon.net>,
        <kyle.teske@ni.com>, <nico@linaro.org>, Felipe Balbi <balbi@ti.com>,
        <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        Rob Landley <rob@landley.net>, <davem@davemloft.net>,
        <cesarb@cesarb.net>, <sameo@linux.intel.com>,
        <akpm@linux-foundation.org>, Linus Walleij <linus.walleij@linaro.org>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <devel@driverdev.osuosl.org>, Alan Tull <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v8 2/4] fpga manager: add sysfs interface document
In-Reply-To: <20150110151118.GA16036@amd>
Message-ID: <alpine.DEB.2.10.1501111009180.2556@shineypoop>
References: <1420575219-27061-1-git-send-email-atull@opensource.altera.com> <1420575219-27061-3-git-send-email-atull@opensource.altera.com> <20150107084819.GA1887@amd> <alpine.DEB.2.02.1501091302370.30067@linuxheads99> <20150109205643.GA5761@amd>
 <4D4EA2D5-68DD-49F7-9E2D-3A0A8F6AF9CA@konsulko.com> <20150110151118.GA16036@amd>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-991411654-1420993764=:2556"
X-Originating-IP: [24.206.110.125]
X-ClientProxiedBy: BN1PR08CA0028.namprd08.prod.outlook.com (10.242.217.156) To
 CY1PR0301MB1242.namprd03.prod.outlook.com (25.161.212.152)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=atull@opensource.altera.com; 
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:CY1PR0301MB1242;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:CY1PR0301MB1242;
X-Forefront-PRVS: 045315E1EE
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(164054003)(51704005)(24454002)(377424004)(189002)(50944004)(54356999)(50986999)(86152002)(76176999)(42186005)(15975445007)(68736005)(66066001)(101416001)(2950100001)(92566002)(512874002)(110136001)(105586002)(40100003)(122386002)(83506001)(19580395003)(19580405001)(41446005)(64706001)(46102003)(33716001)(97736003)(106356001)(87976001)(93886004)(84326002)(86362001)(77156002)(7059030);DIR:OUT;SFP:1101;SCL:1;SRVR:CY1PR0301MB1242;H:shineypoop.local;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB1242;
X-OriginatorOrg: opensource.altera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2015 16:29:16.6066 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY1PR0301MB1242
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8323329-991411654-1420993764=:2556
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT

On Sat, 10 Jan 2015, Pavel Machek wrote:

> On Sat 2015-01-10 10:10:51, Pantelis Antoniou wrote:
> > Hi Pavel,
> > 
> > > On Jan 9, 2015, at 22:56 , Pavel Machek <pavel@denx.de> wrote:
> > > 
> > > On Fri 2015-01-09 13:14:24, atull wrote:
> > >> On Wed, 7 Jan 2015, Pavel Machek wrote:
> > >> 
> > >>> On Tue 2015-01-06 14:13:37, atull@opensource.altera.com wrote:
> > >>>> +
> > >>>> +What:		/sys/class/fpga_manager/<fpga>/firmware
> > >>>> +Date:		October 2014
> > >>>> +KernelVersion:	3.18
> > >>>> +Contact:	Alan Tull <atull@opensource.altera.com>
> > >>>> +Description:	Name of the FPGA image file to load using firmware
> > >>>> class.
> > >>> 
> > >>> This one is ugly: it unneccessarily passes firmware name through the
> > >>> kernel. Just make interface and code simpler by always passing
> > >>> "socfpga-fpga-image" or something like that.
> > >>> 
> > >>> Thanks,
> > >>> 									Pavel
> > >> 
> > >> Hi Pavel,
> > >> 
> > >> It might be ugly.  It's not unnecessary.  Some uses of FPGAs involve
> > >> switching out the FPGA images dynamically under control of the userspace.
> > > 
> > > Then configure udev to load right firmware for you, or ln -s
> > > image-i-want-now socfpga-fpga-image to select the one to read…?
> > > 
> > 
> > Who said that udev is going to be available in the kind of system this is going to end in?
> 
> Noone.
> 
> > Doing ln -s tricks to load a different image? Really?
> 
> But if you don't have udev, you can do ln -s. It is better than
> open-coding symlink functionality into
> /sys/class/fpga_manager/<fpga>/firmware ... cause that's what this is.
> 
> Actually, clean implementation of "firmware" would be symlink in
> sysfs; but I'd say that would be overdoing it.
> 
> > I say the interface is fine as it is.
> 
> I say it is not.
> 									Pavel

Hi Pavel,

I see that we could do it that way and it would eliminate one of the
sysfs files (../fpga_manager/<fpga>/firmware).  Either way we are assuming
that there are fpga images in the filesystem in the firmware search path,
so I don't see why adding a piece of indirection (symlink) makes things
better.

We want to be able to switch out the FPGA image
under control of userspace.  So we don't want an interface that makes
it more cumbersome or tries to pretend that there's only one image.

Previous uses of the firmware layer has been to use it to load once after
bootup; this is different since some use cases will want to switch out
the FPGA image.  If someone wants there to be only one FPGA image on
the FGPA forever, they will probably not be using this framework; their
FPGA will probably be loaded before Linux boots up.

Alan


> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 
--8323329-991411654-1420993764=:2556--
