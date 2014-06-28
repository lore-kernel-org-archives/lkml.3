Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaF1HRu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 03:17:50 -0400
Received: from mail-by2lp0236.outbound.protection.outlook.com ([207.46.163.236]:25842
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751035AbaF1HRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 03:17:49 -0400
X-Greylist: delayed 94068 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jun 2014 03:17:48 EDT
Date: Sat, 28 Jun 2014 13:46:43 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Michael Grzeschik <mgr@pengutronix.de>,
        Punnaiah Choudary Kalluri 
	<punnaiah.choudary.kalluri@xilinx.com>
CC: <robh+dt@kernel.org>, <gregkh@linuxfoundation.org>, <galak@codeaurora.org>,
        <rdunlap@infradead.org>, <michal.simek@xilinx.com>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <kpc528@gmail.com>,
        <kalluripunnaiahchoudary@gmail.com>,
        Punnaiah Choudary Kalluri <punnaia@xilinx.com>
Subject: Re: [PATCH v2 2/2] usb: chipidea: Add support for zynq usb host
 and device controller
Message-ID: <20140628054641.GA14192@shlinux1.ap.freescale.net>
References: <1403868233-5123-1-git-send-email-punnaia@xilinx.com>
 <fa656d2d-a2a8-4b8d-a29b-e89e4bfced3e@BL2FFO11FD034.protection.gbl>
 <20140627125515.GA6025@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140627125515.GA6025@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(51704005)(24454002)(95666004)(104016002)(85306003)(33656002)(105606002)(106466001)(81156004)(102836001)(50466002)(23726002)(107046002)(46406003)(69596002)(26826002)(97736001)(68736004)(83072002)(77982001)(81542001)(15975445006)(83506001)(20776003)(47776003)(31966008)(97756001)(86362001)(50986999)(21056001)(81342001)(79102001)(85852003)(54356999)(76176999)(4396001)(15202345003)(84676001)(80022001)(99396002)(76482001)(92566001)(87936001)(46102001)(74502001)(74662001)(64706001)(83322001)(19580395003)(92726001)(44976005)(6806004);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR03MB086;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 0256C18696
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 02:55:15PM +0200, Michael Grzeschik wrote:
> Hi,
> 
> On Fri, Jun 27, 2014 at 04:53:53PM +0530, Punnaiah Choudary Kalluri wrote:
> > Zynq soc uses Chipidea/Synopsys usb IP core(CI13612). This patch adds
> > necessary glue to allow the chipidea driver to work on zynq soc.
> > 
> 
> Did you see the currently discussed patches for the generic chipidea
> glue?
> 
> http://www.spinics.net/lists/linux-usb/msg109576.html
> 
> Try to improve that code instead writing another version
> of this simple gluecode.
> 

+1 if you think your version can be covered by generic one.

-- 

Best Regards,
Peter Chen
