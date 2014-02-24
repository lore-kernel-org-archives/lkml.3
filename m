Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbaBXKKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 05:10:50 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:50939 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbaBXKKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 05:10:47 -0500
Message-ID: <1393236562.6481.5.camel@iivanov-dev>
Subject: RE: [PATCH RESEND v2 1/3] usb: chipidea: msm: Add device tree
 binding information
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Peter Chen <Peter.Chen@freescale.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Brown <davidb@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Date: Mon, 24 Feb 2014 12:09:22 +0200
In-Reply-To: <94c57dc0d24f45a09985e05591a90bb2@BL2PR03MB226.namprd03.prod.outlook.com>
References: <530512F1.3060304@cogentembedded.com>
	 <1392889988-24312-1-git-send-email-iivanov@mm-sol.com>
	 <94c57dc0d24f45a09985e05591a90bb2@BL2PR03MB226.namprd03.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-24 at 08:15 +0000, Peter Chen wrote: 
> > +CI13xxx (Chipidea) USB controllers
> > +
> > +Required properties:
> > +- compatible:   should contain "qcom,ci-hdrc"
> > +- reg:          offset and length of the register set in the memory map
> > +- interrupts:   interrupt-specifier for the controller interrupt.
> > +- usb-phy:      phandle for the PHY device
> > +- dr_mode:      Sould be "peripheral"
> > +
> > +	gadget@f9a55000 {
> > +		compatible = "qcom,ci-hdrc";
> > +		reg = <0xf9a55000 0x400>;
> > +		dr_mode = "peripheral";
> > +		interrupts = <0 134 0>;
> > +		usb-phy = <&usb_otg>;
> > +	};
> > +
> 
> usb_otg is not a good name for the node of usb phy.

Well, this is just an example. Is this better <&phy0>?

Regards,
Ivan


> 
> Peter
> 


