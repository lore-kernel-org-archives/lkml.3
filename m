Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbaGWOUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:20:14 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:51818 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbaGWOUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 10:20:12 -0400
Date: Wed, 23 Jul 2014 16:14:43 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Jason Cooper <jason@lakedaemon.net>
Cc: benoitm974 <yahoo@perenite.com>, benoitm@perenite.com,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@googlemail.com>
Subject: Re: [PATCH 1/2] Added dts defintion for Lenovo ix4-300d nas
Message-ID: <20140723141443.GC2856@lunn.ch>
References: <1406117232-5962-1-git-send-email-yahoo@perenite.com>
 <20140723134534.GF23220@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723134534.GF23220@titan.lakedaemon.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

> 
> > +			};
> > +
> > +			serial@12000 {
> > +				clocks = <&coreclk 0>;

I don't think you need the clocks property. It should be already set
in armada-xp.dtsi.

> > +				adt7473@2e {
> > +					compatible = "adt7473";

Please include a vendor prefix here. 


> > +					reg = <0x2e>;
> > +				};
> > +
> > +				pcf8563@51 {
> > +					compatible = "pcf8563";

and a vendor prefix here.

> > +	/* warning: you need both eth1 & 0 to be initialize for poweroff to shutdown otherwise it reboots */

What do you mean by initialized? Driver loaded? Interface up? 

> This is a great first version

I agree with Jason, well done.

  Andrew
