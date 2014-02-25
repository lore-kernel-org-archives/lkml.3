Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbaBYB5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 20:57:30 -0500
Received: from mail-bn1lp0158.outbound.protection.outlook.com ([207.46.163.158]:40618
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbaBYB51 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 20:57:27 -0500
From: Peter Chen <Peter.Chen@freescale.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Courtney Cavin <courtney.cavin@sonymobile.com>
CC: "richard.zhao@freescale.com" <richard.zhao@freescale.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        David Brown <davidb@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: RE: [PATCH v2 1/3] usb: chipidea: msm: Add device tree binding
 information
Thread-Topic: [PATCH v2 1/3] usb: chipidea: msm: Add device tree binding
 information
Thread-Index: AQHPMUnzTozOKQ0uAUSwvbpPBeKycZrFM4jw
Date: Tue, 25 Feb 2014 01:57:24 +0000
Message-ID: <2d4d3fed4d9e405fb4c0b7a8a34e9222@BL2PR03MB226.namprd03.prod.outlook.com>
References: <1392729681-21022-1-git-send-email-iivanov@mm-sol.com>
	 <1392729681-21022-2-git-send-email-iivanov@mm-sol.com>
	 <20140218212659.GL1706@sonymobile.com>
	 <1392824602.17130.68.camel@iivanov-dev>
	 <20140219174655.GN1706@sonymobile.com>
 <1393237096.6481.12.camel@iivanov-dev>
In-Reply-To: <1393237096.6481.12.camel@iivanov-dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-forefront-prvs: 01334458E5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(35774003)(24454002)(199002)(189002)(51704005)(377424004)(92566001)(87936001)(95416001)(83322001)(19580395003)(19580405001)(56816005)(80976001)(83072002)(85852003)(94946001)(90146001)(86362001)(93136001)(80022001)(66066001)(93516002)(65816001)(51856001)(94316002)(85306002)(49866001)(47736001)(47976001)(50986001)(77096001)(54316002)(56776001)(76482001)(31966008)(81686001)(81816001)(2656002)(74662001)(87266001)(74502001)(47446002)(53806001)(54356001)(46102001)(4396001)(59766001)(77982001)(79102001)(74876001)(74706001)(76576001)(76786001)(76796001)(69226001)(81542001)(81342001)(63696002)(33646001)(74316001)(74366001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB417;H:BL2PR03MB226.namprd03.prod.outlook.com;CLIP:123.151.195.50;FPR:AC24F42E.A2021DCD.F3D55B68.EEC6841.2031F;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> 
> Hi,
> 
> On Wed, 2014-02-19 at 09:46 -0800, Courtney Cavin wrote:
> > On Wed, Feb 19, 2014 at 04:43:22PM +0100, Ivan T. Ivanov wrote:
> > >
> > > Hi,
> > >
> > > On Tue, 2014-02-18 at 13:26 -0800, Courtney Cavin wrote:
> > > > On Tue, Feb 18, 2014 at 02:21:19PM +0100, Ivan T. Ivanov wrote:
> > > > > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > > > >
> > > > > Document device tree binding information as required by the
> > > > > Qualcomm USB controller.
> > > > >
> > > > > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> > > > > ---
> > > > >  .../devicetree/bindings/usb/msm-hsusb.txt          |   17
> +++++++++++++++++
> > > >
> > > > Although you mentioned to Josh that this is intended for "non-
> standard"
> > > > Chipidea properties, I don't see any other than requiring that
> 'dr_mode'
> > > > must be "peripheral".  It would seem that this should all be
> > > > integrated into a ci3xxx.txt.
> > >
> > > Hm, there is no ci3xxx.txt. The closest match is ci-hdrc-imx.txt.
> > > So it could be ci-hdrc-qcom.txt or my preferred name qcom,ci-hdrc.txt?
> >
> > Sorry, I was referring to ci13xxx-imx.txt, which was apparently moved
> > to ci-hdrc-imx.txt.  I was recommending to merge the two into one
> > 'ci13xxx.txt', as this binding seems to be a new compatible for the
> > same basic chip.  Now perhaps 'ci-hdrc.txt'.
> >
> > Although I agree with Josh that this name should be changed, and I
> > think either of your two suggestions would be acceptable, I would like
> > to at least discuss the possibility of actually merging the two in
> > this series.
> >
> > Comments?
> 
> 
> iMX version have required and recommender properties which are not
> meaningful for QCOM variant. I will prefer separate file. It depends on
> Freescale engineers (now in Cc:)
> 
> 

Unlike dwc3, there is no common dts entry for chipidea core, every platform
uses its own dts to cover both common and platform-specific properties.

I also have plan to use dwc3 style way for dts, but msm platform has still
not used dts, I don't know how many msm platforms need to change, once
you finish transferring msm to dts, I will split common and platform specific
entry.

Peter

