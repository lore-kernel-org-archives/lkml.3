Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbaGOPmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:42:20 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56226 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751509AbaGOPmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:42:17 -0400
Date: Tue, 15 Jul 2014 16:41:34 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Samarth Parikh <samarthp@ymail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] Documentation: added missing semicolon in at25 dts
 example
Message-ID: <20140715154133.GE26465@leverpostej>
References: <1405430449-21283-1-git-send-email-samarthp@ymail.com>
 <53C54A8F.8080909@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C54A8F.8080909@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 04:36:47PM +0100, Randy Dunlap wrote:
> [adding dt bindings people + list]
> 
> On 07/15/14 06:20, Samarth Parikh wrote:
> > Added a missing semicolon ";" in device tree structure
> > example of "EEPROMs (SPI) compatible with Atmel at25" in
> > documentation of device tree bindings.
> > 
> > Signed-off-by: Samarth Parikh <samarthp@ymail.com>

This looks trivial and correct.

Acked-by: Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.

> > ---
> >  Documentation/devicetree/bindings/misc/at25.txt | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/misc/at25.txt b/Documentation/devicetree/bindings/misc/at25.txt
> > index 1d34471..cf830bd 100644
> > --- a/Documentation/devicetree/bindings/misc/at25.txt
> > +++ b/Documentation/devicetree/bindings/misc/at25.txt
> > @@ -24,7 +24,7 @@ Additional compatible properties are also allowed.
> >  Example:
> >  	at25@0 {
> >  		compatible = "atmel,at25", "st,m95256";
> > -		reg = <0>
> > +		reg = <0>;
> >  		spi-max-frequency = <5000000>;
> >  		spi-cpha;
> >  		spi-cpol;
> > 
> 
> 
> -- 
> ~Randy
> 
