Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbaIMG1L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 02:27:11 -0400
Received: from mail-bl2on0148.outbound.protection.outlook.com ([65.55.169.148]:33122
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751490AbaIMG1K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 02:27:10 -0400
From: Peter Chen <Peter.Chen@freescale.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kishon@ti.com" <kishon@ti.com>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "sergei.shtylyov@cogentembedded.com" 
	<sergei.shtylyov@cogentembedded.com>,
        "yoshihiro.shimoda.uh@renesas.com" <yoshihiro.shimoda.uh@renesas.com>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "zmxu@marvell.com" <zmxu@marvell.com>,
        "jszhang@marvell.com" <jszhang@marvell.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4 7/9] usb: rename transceiver and phy to usb_phy in
 ChipIdea
Thread-Topic: [PATCH v4 7/9] usb: rename transceiver and phy to usb_phy in
 ChipIdea
Thread-Index: AQHPx0pkB/pfeOgOfECchw4BwShmBpv7pkgAgAHs9ICAARV98A==
Date: Sat, 13 Sep 2014 06:27:06 +0000
Message-ID: <32020f4ba5294d75811263cbb716948b@BN1PR0301MB0772.namprd03.prod.outlook.com>
References: <1409730040-14200-1-git-send-email-antoine.tenart@free-electrons.com>
 <1409730040-14200-8-git-send-email-antoine.tenart@free-electrons.com>
 <20140911002858.GC3609@peterchendt> <20140912135319.GE18774@kwain>
In-Reply-To: <20140912135319.GE18774@kwain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.50]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 03333C607F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(189002)(24454002)(199003)(31966008)(74662001)(85852003)(80022001)(97736003)(46102001)(79102001)(81542001)(101416001)(86362001)(83072002)(4396001)(81342001)(76576001)(20776003)(66066001)(54356999)(76482001)(50986999)(83322001)(77096002)(21056001)(19580395003)(76176999)(74502001)(92566001)(99396002)(64706001)(87936001)(95666004)(93886004)(85306004)(33646002)(99286002)(106356001)(2656002)(90102001)(110136001)(77982001)(107046002)(105586002)(74316001)(106116001)(108616004)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0772;H:BN1PR0301MB0772.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> On Thu, Sep 11, 2014 at 08:28:59AM +0800, Peter Chen wrote:
> > On Wed, Sep 03, 2014 at 09:40:38AM +0200, Antoine Tenart wrote:
> >
> > Again, rebase my next-tree, and modify the msm part.
> 
> git://github.com/hzpeterchen/linux-usb.git ci-for-usb-next ?
> 

Yes.

> I can do that. But that would be easier if you rebased this branch on top of at
> least v3.17-rc1 so that other series depending on this one could be tested easily
> (like my other series introducing the USB support for Marvell Berlin).
> 
> Antoine
 
Done 

Peter
