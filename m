Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbbAMTov (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 14:44:51 -0500
Received: from mail-bn1bon0095.outbound.protection.outlook.com ([157.56.111.95]:57024
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751161AbbAMTot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 14:44:49 -0500
Date: Tue, 13 Jan 2015 13:44:01 -0600
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@linuxheads99
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
CC: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <hpa@zytor.com>,
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
In-Reply-To: <027665D5-EB1F-47D1-B727-FE236C009FA7@konsulko.com>
Message-ID: <alpine.DEB.2.02.1501131336220.29145@linuxheads99>
References: <1420575219-27061-1-git-send-email-atull@opensource.altera.com> <1420575219-27061-3-git-send-email-atull@opensource.altera.com> <20150107084819.GA1887@amd> <alpine.DEB.2.02.1501091302370.30067@linuxheads99> <20150109205643.GA5761@amd>
 <20150112210134.687176ed@lxorguk.ukuu.org.uk> <20150112214314.GA18610@obsidianresearch.com> <20150113162847.2778b5a5@lxorguk.ukuu.org.uk> <027665D5-EB1F-47D1-B727-FE236C009FA7@konsulko.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="8323329-121362096-1421178262=:29145"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR02CA0015.namprd02.prod.outlook.com (10.141.56.15) To
 BY1PR0301MB1239.namprd03.prod.outlook.com (25.161.203.23)
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=atull@opensource.altera.com; 
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005003);SRVR:BY1PR0301MB1239;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BY1PR0301MB1239;
X-Forefront-PRVS: 045584D28C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(979002)(6009001)(189002)(51704005)(199003)(24454002)(84326002)(86362001)(106356001)(81156004)(86152002)(97736003)(92566002)(512874002)(105586002)(77156002)(62966003)(83506001)(122386002)(69596002)(19580395003)(19580405001)(40100003)(101416001)(46102003)(42186005)(66066001)(60046008)(50986999)(53416004)(33716001)(87976001)(41446005)(2950100001)(110136001)(64706001)(54356999)(93886004)(76176999)(68736005)(7059030)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY1PR0301MB1239;H:linuxheads99.altera.com;FPR:;SPF:None;MLV:ovrnspm;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BY1PR0301MB1239;
X-OriginatorOrg: opensource.altera.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2015 19:44:41.5355 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR0301MB1239
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8323329-121362096-1421178262=:29145
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT

On Tue, 13 Jan 2015, Pantelis Antoniou wrote:

> Hi Alan,
> 
> > On Jan 13, 2015, at 18:28 , One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> wrote:
> > 
> > On Mon, 12 Jan 2015 14:43:14 -0700
> > Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
> > 
> >> On Mon, Jan 12, 2015 at 09:01:34PM +0000, One Thousand Gnomes wrote:
> >>> There are plenty of people today who treat the FPGA as an entirely
> >>> dynamic resource. It's not like flashing a controller, its near
> >>> immediate.
> >> 
> >> But this is a completely different use case. Remember, there are
> >> *megabytes* of internal state in a FPGA, and it isn't really feasible
> >> to dump/restore that state.
> > 
> > People already do it with cases where it makes sense
> > 
> 
> Those people have failed to show up and provide input and/or code.
> 
> >> It is one thing to context switch a maths algorithm that is built to
> >> be stateless, it is quite another to context switch between, say an
> >> ethernet core with an operating Linux Net driver doing DMA and a maths
> >> algorithm.
> > 
> > And people already do it with thins like maths algorithms.
> > 
> 
> Again those people have failed to show up and provide input and/or code.
> 
> >> A DT overlay approach where the overlay has to be unloaded to 'free'
> >> the FPGA makes alot of sense to me for the stateful kernel driver
> >> environment, and open/close/etc makes alot of sense for the stateless
> >> switchable userspace environment - other than sharing configuration
> >> code, is there any overlap between these use cases????
> > 
> > There is a lot of code overlap in things like loading the bitstreams,
> > there is also some overlap because you want to be able to assign FPGA
> > resources. For example if you have four FPGAs and you want to use one for
> > OS stuff (say video) you want the other three to be open/close
> > accessible, but if you've not got a video driver loaded and are running
> > the same board headless you'd like all four to be handed out as normal
> > resources.
> > 
> > So IMHO it's no different to say kmalloc. We don't pre-empt kernel memory
> > and give it to users but we don't reserve memory for kernel and not use
> > it.
> > 
> >>> Its completely dynamic and it will get more so as we switch from the
> >>> painful world of VHDL and friends to high level parallel aware language
> >>> compilers for FPGAs and everyone will be knocking up quick FPGA hacks.
> >> 
> >> Only for some users. In my world FPGAs are filled with bus interface
> >> logic, ethernet controllers, memory controllers, packet processing
> >> engines, etc. This is all incredibly stateful - both in the FPGA
> >> itself, and in the Linux side w/ drviers. It certainly will not ever
> >> work in the model you are talking about.
> > 
> > For those cases I mostly agree (the state in the FPGA isn't always a
> > problem as you can program an FPGA to DMA its state out).
> > 
> >> Even if the digital state could somehow be frozen, dumped and
> >> restored, all the FPGA external interface logic has *ANALOG* state
> >> that cannot ever be dump/restored. It just isn't feasible for that
> >> class of application.
> > 
> > Yes, however as we are starting to get things like OpenCL for FPGA they
> > become extremely attractive for a wide range of purposes that don't
> > involve glueing them to electronica in quite the same way. All the 'GPU
> > as CPU' type uses and more begin to apply.
> > 
> 
> Your points are valid, but they are mostly academic right now.
> 
> We have a lot of well known use cases that this patchset addresses
> satisfactorily. The possible users of the cases you point out are 
> welcome to provide input and working code to address their needs.
> 
> At this point in time, no-one has showed up; is there a reason for
> this needed capability to be delayed in order to address something
> that no-one has expressed interest for?
> 
> > Alan
> > —
> 
> Regards
> 
> — Pantelis
> 
> 

There has been a lot of discussion in the past.  It is possible that
some of the use models are conflicting, but that doesn't really mean
that one model is more valid and needs to be the
winner that determines the only valid way to use FPGAs under Linux.

I like the dynamic usage model and the DT overlays model both.  It
is likely that both will be added and used.

This set of patches gets something started.  The sysfs interface
is built on a set of functions that can be used to build other
interfaces.  An earlier set of patches included DT overlay support,
but I've taken that out for the moment.  It's going into
drivers/staging so that we can use it and grow it.

Alan
--8323329-121362096-1421178262=:29145--
