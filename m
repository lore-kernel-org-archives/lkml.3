Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176AbbAGXzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 18:55:33 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:12645 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137AbbAGXzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 18:55:31 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+ykgwfxrupiH22udRYLcVi
Date: Wed, 7 Jan 2015 15:51:37 -0800
From: Tony Lindgren <tony@atomide.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Vignesh R <vigneshr@ti.com>, Benoit Cousson <bcousson@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: dts: DRA7X: drop id property in pcie_phy
Message-ID: <20150107235136.GK13010@atomide.com>
References: <1418721771-31184-1-git-send-email-vigneshr@ti.com>
 <1418721771-31184-3-git-send-email-vigneshr@ti.com>
 <54993FC0.3090705@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54993FC0.3090705@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kishon Vijay Abraham I <kishon@ti.com> [141223 02:14]:
> 
> 
> On Tuesday 16 December 2014 02:52 PM, Vignesh R wrote:
> > Since phyid is no longer used by pcie driver, this field can be dropped
> > from the DT.
> > 
> > Signed-off-by: Vignesh R <vigneshr@ti.com>
> 
> Acked-by: Kishon Vijay Abraham I <kishon@ti.com>

Applying into omap-for-v3.20/dt thanks.

Tony

> > ---
> >  arch/arm/boot/dts/dra7.dtsi | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
> > index 63bf99be1762..889e3023e68f 100644
> > --- a/arch/arm/boot/dts/dra7.dtsi
> > +++ b/arch/arm/boot/dts/dra7.dtsi
> > @@ -1111,7 +1111,6 @@
> >  					      "wkupclk", "refclk",
> >  					      "div-clk", "phy-div";
> >  				#phy-cells = <0>;
> > -				id = <1>;
> >  				ti,hwmods = "pcie1-phy";
> >  			};
> >  
> > @@ -1132,7 +1131,6 @@
> >  					      "div-clk", "phy-div";
> >  				#phy-cells = <0>;
> >  				ti,hwmods = "pcie2-phy";
> > -				id = <2>;
> >  				status = "disabled";
> >  			};
> >  		};
> > 
