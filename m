Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbaIBKSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 06:18:36 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:50859
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753621AbaIBKSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 06:18:34 -0400
Date: Tue, 2 Sep 2014 18:18:24 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <kishon@ti.com>,
        <stern@rowland.harvard.edu>, <sergei.shtylyov@cogentembedded.com>,
        <yoshihiro.shimoda.uh@renesas.com>,
        <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 8/9] usb: chipidea: move usb_otg into struct ci_hdrc
Message-ID: <20140902101823.GB22794@peterchendt>
References: <1408722621-3635-1-git-send-email-antoine.tenart@free-electrons.com>
 <1408722621-3635-9-git-send-email-antoine.tenart@free-electrons.com>
 <20140826102239.GD16758@peterchendt> <20140829142535.GA16609@kwain>
 <20140901011341.GD3854@peterchendt> <20140902090832.GB12536@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140902090832.GB12536@kwain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(51704005)(199003)(24454002)(23756003)(81542001)(83506001)(26826002)(106466001)(50986999)(105606002)(92726001)(54356999)(92566001)(74502001)(86362001)(31966008)(50466002)(33656002)(4396001)(102836001)(79102001)(64706001)(99396002)(68736004)(81342001)(81156004)(104016003)(6806004)(83072002)(69596002)(57986006)(107046002)(85852003)(110136001)(46102001)(85306004)(87936001)(77982001)(76482001)(44976005)(76176999)(83322001)(90102001)(47776003)(93886004)(95666004)(20776003)(97736001)(84676001)(33716001)(21056001)(74662001)(80022001);DIR:OUT;SFP:;SCL:1;SRVR:BL2PR03MB561;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0322B4EDE1
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 11:08:32AM +0200, Antoine Tenart wrote:
> Hi,
> 
> On Mon, Sep 01, 2014 at 09:13:43AM +0800, Peter Chen wrote:
> > On Fri, Aug 29, 2014 at 04:25:35PM +0200, Antoine Tenart wrote:
> > > On Tue, Aug 26, 2014 at 06:22:40PM +0800, Peter Chen wrote:
> > > > On Fri, Aug 22, 2014 at 05:50:19PM +0200, Antoine Ténart wrote:
> > > > 
> > > > If the common usb_otg and usb_phy struct still has another's pointer, you
> > > > may not need to add this patch.
> > > 
> > > Except if we want to access the OTG member when not using an USB PHY.
> > 
> > If there is no USB PHY, the probe at core.c will turn error.
> 
> I meant if we use a PHY from the common PHY framework (struct phy) and
> not one from the USB one (struct usb_phy). The 'struct phy' does not
> have a pointer to an OTG structure.
> 

Ok, agree.

-- 
Best Regards,
Peter Chen
