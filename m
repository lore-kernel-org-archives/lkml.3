Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbaKLCju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:39:50 -0500
Received: from mail-bl2on0126.outbound.protection.outlook.com ([65.55.169.126]:51040
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755133AbaKLCjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 21:39:47 -0500
Date: Wed, 12 Nov 2014 09:33:09 +0800
From: Peter Chen <peter.chen@freescale.com>
To: Felipe Balbi <balbi@ti.com>
CC: Antoine Tenart <antoine.tenart@free-electrons.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kishon@ti.com" <kishon@ti.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "zmxu@marvell.com" <zmxu@marvell.com>,
        "jszhang@marvell.com" <jszhang@marvell.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 0/7] usb: add support for the generic PHY framework
Message-ID: <20141112013308.GB15348@shlinux2>
References: <1414690879-7184-1-git-send-email-antoine.tenart@free-electrons.com>
 <07c7cfed25af4bdb9e34b6ad1aaed0c7@BN1PR0301MB0772.namprd03.prod.outlook.com>
 <20141107180820.GO15036@saruman> <20141107180852.GP15036@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141107180852.GP15036@saruman>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(24454002)(51704005)(199003)(50466002)(107046002)(105606002)(106466001)(87936001)(97736003)(21056001)(95666004)(76176999)(44976005)(84676001)(31966008)(33656002)(33716001)(6806004)(102836001)(93886004)(46102003)(20776003)(47776003)(64706001)(46406003)(86362001)(120916001)(54356999)(99396003)(50986999)(4396001)(110136001)(92566001)(104016003)(97756001)(23726002)(92726001)(77156002)(68736004)(62966003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0625;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0625;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0625;
X-Forefront-PRVS: 03932714EB
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0625;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 12:08:52PM -0600, Felipe Balbi wrote:
> On Fri, Nov 07, 2014 at 12:08:20PM -0600, Felipe Balbi wrote:
> > Hi,
> > 
> > On Fri, Nov 07, 2014 at 01:33:25PM +0000, Peter Chen wrote:
> > > 
> > > 
> > >  
> > > > 
> > > > Antoine Tenart (7):
> > > >   usb: move the OTG state from the USB PHY to the OTG structure
> > > >   usb: rename phy to usb_phy in OTG
> > > >   usb: add support to the generic PHY framework in OTG
> > > >   usb: allow to supply the PHY in the drivers when using HCD
> > > >   usb: chipidea: rename transceiver and phy to usb_phy
> > > >   usb: chipidea: move usb_otg into struct ci_hdrc
> > > >   usb: chipidea: add support to the generic PHY framework
> > > > 
> > > 
> > > Hi Felipe,
> > > 
> > > I find you queue the patch 1st-4th and 7th in your next tree, how you queue
> > > the 7th without queueing 5th and 6th, they have some relationships.
> > > 
> > > Will you queue 5th and 6th, or I queue them (5th- 7th) through my chipidea patch set?
> > 
> > argh, somehow I missed them. I'll add both to my testing/next. Sorry for
> > the confusion. I thought I had them all.
> 
> oh, they don't apply.
> 

Oh, I know the reason why you can apply 7th, without apply 5th and 6th.
At your next tree, the 4th, 5th, and 6th patches were squashed, and
it becomes "4th" patches in this series.
The shortlog is: 
usb: allow to supply the PHY in the drivers when using HCD
commit id is:
"ef44cb4226d132146e44f8ea562a16b27ff61126"

Peter
