Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751653AbaHIN0N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 09:26:13 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:23008
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750900AbaHIN0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 09:26:08 -0400
Date: Sat, 9 Aug 2014 21:25:47 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: "edubezval@gmail.com" <edubezval@gmail.com>
CC: Anson Huang <b20788@freescale.com>, Zhang Rui <rui.zhang@intel.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH V3] Thermal: imx: add i.mx6sx thermal support
Message-ID: <20140809132544.GA8981@dragon>
References: <1407309129-5562-1-git-send-email-b20788@freescale.com>
 <20140807085024.GE27051@dragon>
 <CAC-25o_C1ijr64NyA22JqfS9Z90-v9iseaYzcf1ojy_QNXzExA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAC-25o_C1ijr64NyA22JqfS9Z90-v9iseaYzcf1ojy_QNXzExA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Matching-Connectors: 130520643534795978;(91ab9b29-cfa4-454e-5278-08d120cd25b8);()
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009004)(6009001)(448002)(51704005)(24454002)(377454003)(189002)(199002)(41574002)(77982001)(6806004)(31966008)(92726001)(23726002)(76482001)(85306004)(1411001)(97736001)(76176999)(87936001)(54356999)(92566001)(104016003)(46102001)(110136001)(85852003)(50986999)(81342001)(97756001)(81542001)(33656002)(83072002)(47776003)(19580405001)(83322001)(33716001)(4396001)(99396002)(19580395003)(95666004)(50466002)(83506001)(106466001)(85326001)(84676001)(107046002)(2351001)(68736004)(57986006)(20776003)(21056001)(86362001)(79102001)(74662001)(44976005)(102836001)(80022001)(46406003)(26826002)(74502001)(64706001)(2501001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB353;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02981BE340
Authentication-Results: spf=permerror (sender IP is 192.88.168.50)
 smtp.mailfrom=shawn.guo@linaro.org; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 08, 2014 at 08:15:54AM -0400, edubezval@gmail.com wrote:
> Hello Shawn,
> 
> On Thu, Aug 7, 2014 at 4:50 AM, Shawn Guo <shawn.guo@linaro.org> wrote:
> > On Wed, Aug 06, 2014 at 03:12:09PM +0800, Anson Huang wrote:
> >> i.MX6SX has some new features of thermal interrupt function,
> >> there are LOW, HIGH and PANIC irq for thermal sensor, so add
> >> platform data to separate different thermal version;
> >>
> >> The reset value of LOW ALARM is 0 which means the highest
> >> temp, so the LOW ALARM will be triggered once irq is enabled,
> >> so we need to correct it before enabling thermal irq;
> >>
> >> Enable PANIC ALARM as critical trip point, it will trigger
> >> system reset via SRC module once PANIC IRQ is triggered, it
> >> is pure hardware function, so use it instead of software
> >> reset by cooling device.
> >>
> >> Signed-off-by: Anson Huang <b20788@freescale.com>
> >
> > Tested-by: Shawn Guo <shawn.guo@linaro.org>
> 
> Thanks!
> 
> Did you have the chance to test on both? i.MX6Q and i.MX6SX?

Yes, I did test on both i.MX6Q and i.MX6SX.

Shawn
