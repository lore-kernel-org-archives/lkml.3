Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaKFKCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 05:02:11 -0500
Received: from mail-bl2on0121.outbound.protection.outlook.com ([65.55.169.121]:45568
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752597AbaKFKCF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 05:02:05 -0500
From: Peter Chen <Peter.Chen@freescale.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
CC: "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "zmxu@marvell.com" <zmxu@marvell.com>,
        "jszhang@marvell.com" <jszhang@marvell.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/6] usb: chipidea: setup ci_hdrc_platform_data in core
 driver
Thread-Topic: [PATCH 1/6] usb: chipidea: setup ci_hdrc_platform_data in core
 driver
Thread-Index: AQHP9DXN0B6KNbdoa0S7b1O/uf6RxpxIhRWAgArMYACAABdUYA==
Date: Thu, 6 Nov 2014 10:02:00 +0000
Message-ID: <47e2cb9fdb474eb3a48b41c64ecfbcd1@BN1PR0301MB0772.namprd03.prod.outlook.com>
References: <1414669007-9850-1-git-send-email-antoine.tenart@free-electrons.com>
 <20141030114341.GA7798@kwain> <20141106083746.GB8096@kwain>
In-Reply-To: <20141106083746.GB8096@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [192.88.158.211]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0772;UriScan:;
x-exchange-antispam-report-test: UriScan:;
x-forefront-prvs: 0387D64A71
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(24454002)(51704005)(189002)(46102003)(2656002)(87936001)(15202345003)(108616004)(92566001)(50986999)(76176999)(77096003)(31966008)(54356999)(122556002)(64706001)(86362001)(40100003)(33646002)(76576001)(74316001)(77156002)(62966003)(4396001)(15975445006)(99396003)(120916001)(106356001)(106116001)(21056001)(105586002)(110136001)(19580395003)(97736003)(66066001)(20776003)(95666004)(107046002)(99286002)(101416001)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0772;H:BN1PR0301MB0772.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0721;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> Subject: Re: [PATCH 1/6] usb: chipidea: setup ci_hdrc_platform_data in core
> driver
> 
> Hi guys,
> 
> On Thu, Oct 30, 2014 at 12:43:41PM +0100, Antoine Tenart wrote:
> > On Thu, Oct 30, 2014 at 12:36:41PM +0100, Antoine Tenart wrote:
> > > Hello,
> > >
> > > This series introduce the ci_hdrc_get_platdata function to help
> > > setting up the ChipIdea internal ci_hdrc_platform_data structure.
> > > This helps avoiding duplicating code.
> > >
> > > This series comes from a duscission on Berlin's USB pacthes where it
> > > was asked to move the PHY phandle handling in the ChipIdea core[1].
> > >
> > > With the introduction of the ci_hdrc_get_platdata function, the old
> > > ci_get_platdata function is removed. Changes in ChipIdea drivers
> > > have also been made.
> > >
> > > This series is needed for the Berlin USB support and has been tested
> > > with an updated version of the USB Berlin driver (not in mainline yet).
> > >
> > > [1]
> > > http://lists.infradead.org/pipermail/linux-arm-kernel/2014-October/2
> > > 92383.html
> > >
> >
> > Of course, this is the cover letter so it should be [PATCH 0/6].
> >
> > This series depends on the generic PHY framework support in USB and CI:
> > https://lkml.org/lkml/2014/10/28/807
> 
> Any news? I have another series depending on this one waiting in my queue.
> 

I have some issues on hand now, will review them next week.

Peter
