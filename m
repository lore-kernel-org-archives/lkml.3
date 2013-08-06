Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab3HFRxk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 13:53:40 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:50142 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab3HFRxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 13:53:38 -0400
Subject: Re: [RFC 2/2] usb: dwc3: Add Qualcomm DWC3 glue layer driver
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: Pawel Moll <pawel.moll@arm.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
In-Reply-To: <1375802112.12043.62.camel@hornet>
References: <1375789991-30041-1-git-send-email-iivanov@mm-sol.com>
	 <1375789991-30041-3-git-send-email-iivanov@mm-sol.com>
	 <1375791698.12043.53.camel@hornet>
	 <1375796793.2027.20.camel@iivanov-dev.int.mm-sol.com>
	 <1375802112.12043.62.camel@hornet>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Aug 2013 20:53:36 +0300
Message-ID: <1375811616.2888.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 16:15 +0100, Pawel Moll wrote:
> On Tue, 2013-08-06 at 14:46 +0100, Ivan T. Ivanov wrote:
> > > > +			reg = <0xf9200000 0xcd00>;
> > > > +			interrupts = <0 131 0>;
> > > > +			interrupt-names = "irq";
> > > > +			usb-phy = <&dwc3_usb2>, <&dwc3_usb3>;
> > > > +			tx-fifo-resize;
> > > > +		};
> > > > +	};
> > > 
> > > And now I'm really confused... Maybe it's just lack of documentation...
> > > 
> > > How does the "qcom,dwc-usb3-msm" relate to "qcom,dwc-usb3"?
> > 
> > Not sure from where you get this "qcom,dwc-usb3", but now I think
> > that "qcom,dwc-usb3" should be enough for compatible.  
> 
> The other patch introduces "qcom,dwc3-usb3" compatible value...

Oh, of course. Intention was that "qcom,dwc-usb3" will handle SS-PHY, 
while "qcom,dwc-usb2" will handle HS-PHY. Probably it will better if
I rename them to "qcom,dwc-ssphy" and "qcom,dwc-hsphy".

Regards,
Ivan

> 
> Paweł


