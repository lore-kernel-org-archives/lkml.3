Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaBXKet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:34:49 -0500
Received: from mail-bn1lp0149.outbound.protection.outlook.com ([207.46.163.149]:49805
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbaBXKeq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:34:46 -0500
X-Greylist: delayed 916 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Feb 2014 05:34:46 EST
From: Peter Chen <Peter.Chen@freescale.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        David Brown <davidb@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH RESEND v2 1/3] usb: chipidea: msm: Add device tree
 binding information
Thread-Topic: [PATCH RESEND v2 1/3] usb: chipidea: msm: Add device tree
 binding information
Thread-Index: AQHPLiH43OV+zb4700mLy7ldJun5K5rEFMEQgAAf9ACAAAJxwA==
Date: Mon, 24 Feb 2014 10:19:25 +0000
Message-ID: <4ba05bf270f6482c97fdc920969f1f54@BL2PR03MB226.namprd03.prod.outlook.com>
References: <530512F1.3060304@cogentembedded.com>
	 <1392889988-24312-1-git-send-email-iivanov@mm-sol.com>
	 <94c57dc0d24f45a09985e05591a90bb2@BL2PR03MB226.namprd03.prod.outlook.com>
 <1393236562.6481.5.camel@iivanov-dev>
In-Reply-To: <1393236562.6481.5.camel@iivanov-dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-forefront-prvs: 0132C558ED
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(189002)(199002)(377424004)(51704005)(24454002)(76786001)(76796001)(76576001)(81542001)(81342001)(69226001)(79102001)(77982001)(59766001)(95666003)(74876001)(74706001)(74316001)(74366001)(33646001)(63696002)(66066001)(80022001)(65816001)(94316002)(93516002)(86362001)(93136001)(95416001)(92566001)(87936001)(94946001)(90146001)(80976001)(56816005)(83072002)(83322001)(19580405001)(85852003)(51856001)(46102001)(4396001)(85306002)(54356001)(53806001)(77096001)(47736001)(49866001)(47976001)(50986001)(74502001)(47446002)(81816001)(2656002)(87266001)(74662001)(56776001)(54316002)(31966008)(81686001)(76482001)(24736002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB417;H:BL2PR03MB226.namprd03.prod.outlook.com;CLIP:123.151.195.50;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> 
> On Mon, 2014-02-24 at 08:15 +0000, Peter Chen wrote:
> > > +CI13xxx (Chipidea) USB controllers
> > > +
> > > +Required properties:
> > > +- compatible:   should contain "qcom,ci-hdrc"
> > > +- reg:          offset and length of the register set in the memory
> map
> > > +- interrupts:   interrupt-specifier for the controller interrupt.
> > > +- usb-phy:      phandle for the PHY device
> > > +- dr_mode:      Sould be "peripheral"
> > > +
> > > +	gadget@f9a55000 {
> > > +		compatible = "qcom,ci-hdrc";
> > > +		reg = <0xf9a55000 0x400>;
> > > +		dr_mode = "peripheral";
> > > +		interrupts = <0 134 0>;
> > > +		usb-phy = <&usb_otg>;
> > > +	};
> > > +
> >
> > usb_otg is not a good name for the node of usb phy.
> 
> Well, this is just an example. Is this better <&phy0>?
> 

<&usbphy0> is better since we have ethernet, sata, pcie phy.

Peter

