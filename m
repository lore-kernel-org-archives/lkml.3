Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbaCFShl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 13:37:41 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:35382 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752595AbaCFShi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 13:37:38 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+2tIRxtYKBAFuVRM7aIUER
Date: Thu, 6 Mar 2014 10:37:30 -0800
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: George Cherian <george.cherian@ti.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, anatol.pomozov@gmail.com,
        gregkh@linuxfoundation.org, balbi@ti.com, kishon@ti.com,
        rob@landley.net, galak@codeaurora.org, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, pawel.moll@arm.com, robh+dt@kernel.org,
        bcousson@baylibre.com
Subject: Re: [PATCH 2/5] ARM: dts: AM4372: Add USB nodes
Message-ID: <20140306183729.GC1381@atomide.com>
References: <1393854834-23810-1-git-send-email-george.cherian@ti.com>
 <1393854834-23810-3-git-send-email-george.cherian@ti.com>
 <53183699.8070106@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53183699.8070106@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [140306 00:52]:
> On 03/03/2014 03:53 PM, George Cherian wrote:
> > --- a/arch/arm/boot/dts/am4372.dtsi
> > +++ b/arch/arm/boot/dts/am4372.dtsi
> > @@ -698,6 +698,105 @@
> >  			       <&edma 11>;
> >  			dma-names = "tx", "rx";
> >  		};
> > +
> > +		am43xx_control_usb2phy1: control-phy@44e10620 {
> > +			compatible = "ti,control-phy-am437usb2";
> 
> Since this is the first usage of this compatible ID, we still have room to
> change it to be better. Tony's suggestion was to use "ti,control-phy-am437-usb2"

Or from grepping point of view ti,control-phy-usb2-am437 might be better?

Regards,

Tony 
