Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab3HFPPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 11:15:18 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56740 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976Ab3HFPPP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 11:15:15 -0400
Message-ID: <1375802112.12043.62.camel@hornet>
Subject: Re: [RFC 2/2] usb: dwc3: Add Qualcomm DWC3 glue layer driver
From: Pawel Moll <pawel.moll@arm.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
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
Date: Tue, 06 Aug 2013 16:15:12 +0100
In-Reply-To: <1375796793.2027.20.camel@iivanov-dev.int.mm-sol.com>
References: <1375789991-30041-1-git-send-email-iivanov@mm-sol.com>
	 <1375789991-30041-3-git-send-email-iivanov@mm-sol.com>
	 <1375791698.12043.53.camel@hornet>
	 <1375796793.2027.20.camel@iivanov-dev.int.mm-sol.com>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 06 Aug 2013 15:15:12.0487 (UTC) FILETIME=[BF344F70:01CE92B7]
X-MC-Unique: 113080616151303701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 14:46 +0100, Ivan T. Ivanov wrote:
> > > +			reg = <0xf9200000 0xcd00>;
> > > +			interrupts = <0 131 0>;
> > > +			interrupt-names = "irq";
> > > +			usb-phy = <&dwc3_usb2>, <&dwc3_usb3>;
> > > +			tx-fifo-resize;
> > > +		};
> > > +	};
> > 
> > And now I'm really confused... Maybe it's just lack of documentation...
> > 
> > How does the "qcom,dwc-usb3-msm" relate to "qcom,dwc-usb3"?
> 
> Not sure from where you get this "qcom,dwc-usb3", but now I think
> that "qcom,dwc-usb3" should be enough for compatible.  

The other patch introduces "qcom,dwc3-usb3" compatible value...

Paweł


