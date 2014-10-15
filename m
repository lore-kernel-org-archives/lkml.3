Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbaJOUY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 16:24:26 -0400
Received: from mail-by2on0073.outbound.protection.outlook.com ([207.46.100.73]:44281
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750917AbaJOUYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 16:24:25 -0400
Date: Wed, 15 Oct 2014 15:17:51 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Pavel Machek <pavel@denx.de>
CC: <dinguyen@opensource.altera.com>, <linux@arm.linux.org.uk>,
        <arnd@arndb.de>, <s.trumtrar@pengutronix.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v3 2/2] socfpga: support suspend to ram
In-Reply-To: <20141015075001.GB10720@amd>
Message-ID: <alpine.DEB.2.02.1410151517350.28205@atx-linux-37>
References: <1413315219-28885-1-git-send-email-atull@opensource.altera.com> <1413315219-28885-3-git-send-email-atull@opensource.altera.com> <20141015075001.GB10720@amd>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY1PR00CA0027.namprd00.prod.outlook.com (25.160.102.37) To
 BY2PR03MB314.namprd03.prod.outlook.com (10.141.139.19)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB314;
X-Forefront-PRVS: 0365C0E14B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(24454002)(41574002)(51704005)(377424004)(189002)(101416001)(120916001)(47776003)(85306004)(54356999)(76482002)(20776003)(86152002)(19580405001)(102836001)(92726001)(64706001)(19580395003)(85852003)(92566001)(87976001)(83506001)(50466002)(66066001)(77096002)(15975445006)(4396001)(69596002)(46406003)(86362001)(23726002)(80022003)(46102003)(21056001)(110136001)(107046002)(33716001)(53416004)(97736003)(76176999)(122386002)(50986999)(99396003)(15202345003)(105586002)(81156004)(106356001)(31966008)(42186005)(95666004)(40100003)(3556765001);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB314;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2014, Pavel Machek wrote:

> On Tue 2014-10-14 14:33:39, atull@opensource.altera.com wrote:
> > From: Alan Tull <atull@opensource.altera.com>
> > 
> > Add code that requests that the sdr controller go into
> > self-refresh mode.  This code is run from ocram.
> > 
> > This patch assumes that u-boot has already configured sdr:
> >   sdr.ctrlcfg.lowpwreq.selfrfshmask = 3
> >   sdr.ctrlcfg.lowpwrtiming.clkdisablecycles = 8
> >   sdr.ctrlcfg.dramtiming4.selfrfshexit = 512
> > 
> > How to suspend to ram:
> >  $ echo enabled > \
> > /sys/devices/soc/ffc02000.serial0/tty/ttyS0/power/wakeup
> > 
> >  $ echo -n mem > /sys/power/state
> > 
> > Signed-off-by: Alan Tull <atull@opensource.altera.com>
> 
> Acked-by: Pavel Machek <pavel@denx.de>
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> 

Thanks!

Alan

