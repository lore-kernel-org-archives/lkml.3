Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964885AbaKLCQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:16:43 -0500
Received: from mail-bn1on0116.outbound.protection.outlook.com ([157.56.110.116]:38592
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933213AbaKLCQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 21:16:40 -0500
Date: Wed, 12 Nov 2014 09:10:03 +0800
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
Message-ID: <20141112010959.GA15348@shlinux2>
References: <1414690879-7184-1-git-send-email-antoine.tenart@free-electrons.com>
 <07c7cfed25af4bdb9e34b6ad1aaed0c7@BN1PR0301MB0772.namprd03.prod.outlook.com>
 <20141107180820.GO15036@saruman> <20141107180852.GP15036@saruman>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141107180852.GP15036@saruman>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(51704005)(24454002)(84676001)(97756001)(102836001)(33716001)(50466002)(86362001)(93886004)(46406003)(47776003)(20776003)(68736004)(62966003)(106466001)(107046002)(46102003)(21056001)(33656002)(95666004)(77156002)(105606002)(64706001)(99396003)(120916001)(31966008)(104016003)(110136001)(23726002)(4396001)(54356999)(97736003)(76176999)(50986999)(87936001)(92566001)(92726001)(6806004)(44976005);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0628;H:tx30smr01.am.freescale.net;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0628;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0628;
X-Forefront-PRVS: 03932714EB
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Peter.Chen@freescale.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0628;
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

Hi Felipe, I still not see Antoine's chipidea patch in your tree.
I assume you will do it soon.
And there are some coming chipidea patches (Antoine & me), I will do
further work based on it.

Peter
