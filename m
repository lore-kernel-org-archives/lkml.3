Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbaIHVjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 17:39:00 -0400
Received: from mail-bn1bn0100.outbound.protection.outlook.com ([157.56.110.100]:8384
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754843AbaIHVi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 17:38:58 -0400
X-Greylist: delayed 1935 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Sep 2014 17:38:58 EDT
Date: Mon, 8 Sep 2014 16:00:54 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Pavel Machek <pavel@denx.de>
CC: <gregkh@linuxfoundation.org>, <jgunthorpe@obsidianresearch.com>,
        <hpa@zytor.com>, <monstr@monstr.eu>, <michal.simek@xilinx.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <pantelis.antoniou@konsulko.com>, <robh+dt@kernel.org>,
        <grant.likely@linaro.org>, <broonie@kernel.org>, <philip@balister.org>,
        <rubini@gnudd.com>, <s.trumtrar@pengutronix.de>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH 0/3] Yet another stab at a fpga framework
In-Reply-To: <20140907185700.GA26553@amd>
Message-ID: <alpine.DEB.2.02.1409081559320.3201@atx-linux-37>
References: <1406932118-13885-1-git-send-email-atull@opensource.altera.com> <20140907185700.GA26553@amd>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: DM2PR04CA024.namprd04.prod.outlook.com (10.141.154.142) To
 BLUPR03MB312.namprd03.prod.outlook.com (10.141.48.28)
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;UriScan:;
X-Forefront-PRVS: 03283976A6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009018)(6009001)(51704005)(189002)(199003)(24454002)(51914003)(164054003)(15975445006)(101416001)(46102001)(66066001)(80022001)(79102001)(31966008)(15202345003)(74502001)(74662001)(77982001)(50986999)(76482001)(95666004)(85306004)(21056001)(97736003)(50466002)(64706001)(19580395003)(54356999)(42186005)(81342001)(83322001)(20776003)(76176999)(69596002)(83506001)(33716001)(81542001)(53416004)(77096002)(102836001)(107046002)(23726002)(92726001)(106356001)(81156004)(46406003)(87976001)(99396002)(92566001)(86362001)(110136001)(90102001)(4396001)(83072002)(105586002)(85852003)(86152002)(3556765001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB312;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Sep 2014, Pavel Machek wrote:

> Hi!
> 
> > [resend with fixed email settings]
> > 
> > The idea of the framework is to provide consistent ways of
> > programming raw images into FPGA's.
> > 
> > Programming from device tree overlays is supported.
> > 
> > The core (fpga-mgr.c) does not include a userspace interface
> > and just exports kernel functions.
> > 
> > This approach separates the core from the interfaces.
> > 
> > Each interface can be enabled or disabled in the defconfig.
> > In some production contexts, interfaces that might be used
> > during development can be disabled.
> > 
> > The core exports kernel functions to:
> >   * write the fpga from a buffer or using the firmware layer
> >   * get fpga status
> >   * find a particular fpga manager from a device tree phandle
> >   * register/unregister lower level fpga drivers.
> > 
> > The bus allows us to:
> >   * program fpga from a device tree overlay using firmware.
> >   * automatically reload firmware and reprogram fpga during resume.
> > 
> > The sysfs interface:
> >   * read only, get the name and status of fpga manager.
> > 
> > I have a configfs interface patch which I haven't included,
> > adds configfs as a separate file.
> 
> Thanks for the patches... is there new version? Is that corresponding
> socfpga code?
> 
> I'd like to configure fpga with .rbf file on board similar to SocKit.
> 
> Thanks,
> 								Pavel

Yes, hopefully next week.

Regards,
Alan


> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 
