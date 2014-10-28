Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbaJ1WBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:01:21 -0400
Received: from [157.56.110.65] ([157.56.110.65]:43472 "EHLO
	na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754519AbaJ1WBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:01:19 -0400
X-Greylist: delayed 2121 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Oct 2014 18:01:19 EDT
Date: Tue, 28 Oct 2014 16:53:47 -0500
From: atull <atull@opensource.altera.com>
X-X-Sender: atull@atx-linux-37
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: <jgunthorpe@obsidianresearch.com>, <hpa@zytor.com>, <monstr@monstr.eu>,
        <michal.simek@xilinx.com>, <rdunlap@infradead.org>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <pantelis.antoniou@konsulko.com>,
        <robh+dt@kernel.org>, <grant.likely@linaro.org>,
        <iws@ovro.caltech.edu>, <linux-doc@vger.kernel.org>, <pavel@denx.de>,
        <broonie@kernel.org>, <philip@balister.org>, <rubini@gnudd.com>,
        <jason@lakedaemon.net>, <kyle.teske@ni.com>, <nico@linaro.org>,
        <balbi@ti.com>, <m.chehab@samsung.com>, <davidb@codeaurora.org>,
        <rob@landley.net>, <davem@davemloft.net>, <cesarb@cesarb.net>,
        <sameo@linux.intel.com>, <akpm@linux-foundation.org>,
        <linus.walleij@linaro.org>, <mgerlach@opensource.altera.com>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v2 2/3] ARM: dts: socfpga: fpga bridges bindings docs
In-Reply-To: <alpine.DEB.2.02.1410281601570.11910@atx-linux-37>
Message-ID: <alpine.DEB.2.02.1410281651490.11910@atx-linux-37>
References: <1414108267-22058-1-git-send-email-atull@opensource.altera.com> <1414108267-22058-3-git-send-email-atull@opensource.altera.com> <20141024070042.GL10262@pengutronix.de> <alpine.DEB.2.02.1410281601570.11910@atx-linux-37>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY2PR04CA033.namprd04.prod.outlook.com (10.141.249.151) To
 BL2PR03MB307.namprd03.prod.outlook.com (10.141.68.21)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB307;
X-Forefront-PRVS: 0378F1E47A
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(24454002)(189002)(199003)(51704005)(64706001)(106356001)(46406003)(81156004)(21056001)(20776003)(47776003)(66066001)(95666004)(107046002)(50466002)(105586002)(33716001)(23726002)(40100003)(31966008)(102836001)(77096002)(92726001)(53416004)(85306004)(93886004)(110136001)(87976001)(122386002)(80022003)(86362001)(92566001)(86152002)(4396001)(46102003)(97736003)(83506001)(76482002)(101416001)(42186005)(85852003)(54356999)(99396003)(76176999)(50986999)(69596002)(120916001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB307;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Oct 2014, atull wrote:

> On Fri, 24 Oct 2014, Steffen Trumtrar wrote:

> > 
> > > + - init-val       : 0 if driver should disable bridge at startup
> > > +                    1 if driver should enable bridge at startup
> > > +                    driver leaves bridge in current state if property not
> > > +                    specified.
> > > +
> > 
> > Configuration in the DT? Really?

The FPGA can be programmed by several different methods (eeprom, jtag,
preloader, Linux).  The guiding principle is: whoever programmed the
FPGA should release the bridge.  At one point, we thought 'init-val'
would be needed, but I think it can be taken out and we won't miss it.

Alan
