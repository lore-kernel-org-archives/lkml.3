Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbaDRWaD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 18:30:03 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:33512 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbaDRW36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 18:29:58 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19mshICvShVDpLV2LBc7haZ
Date: Fri, 18 Apr 2014 15:29:54 -0700
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: balbi@ti.com, kishon@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/1] ARM: dts: omap5: Add clocks to USB3 PHY node
Message-ID: <20140418222954.GH21823@atomide.com>
References: <1396348647-11545-1-git-send-email-rogerq@ti.com>
 <1396348647-11545-2-git-send-email-rogerq@ti.com>
 <20140401141308.GB4717@saruman.home>
 <534B8CC3.7050008@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534B8CC3.7050008@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [140414 00:23]:
> Hi Tony,
> 
> On 04/01/2014 05:13 PM, Felipe Balbi wrote:
> > On Tue, Apr 01, 2014 at 01:37:27PM +0300, Roger Quadros wrote:
> >> The USB3 PHY driver (ti-pipe3) was updated so that the relevant
> >> clock phandles are expected in the DT node.
> >> Provide the necessary clocks.
> >>
> >> Reported-by: Kishon Vijay Abraham I <kishon@ti.com>
> >> Signed-off-by: Roger Quadros <rogerq@ti.com>
> > 
> > Great!!!
> > 
> > Acked-by: Felipe Balbi <balbi@ti.com>
> 
> Could you please pick this up for 3.15-rc? Thanks.

Yes applying into omap-for-v3.15/fixes thanks.

Tony
 
> >>  arch/arm/boot/dts/omap5.dtsi | 6 ++++++
> >>  1 file changed, 6 insertions(+)
> >>
> >> diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
> >> index 757f0b9..4df1e7a 100644
> >> --- a/arch/arm/boot/dts/omap5.dtsi
> >> +++ b/arch/arm/boot/dts/omap5.dtsi
> >> @@ -794,6 +794,12 @@
> >>  				      <0x4a084c00 0x40>;
> >>  				reg-names = "phy_rx", "phy_tx", "pll_ctrl";
> >>  				ctrl-module = <&omap_control_usb3phy>;
> >> +				clocks = <&usb_phy_cm_clk32k>,
> >> +					 <&sys_clkin>,
> >> +					 <&usb_otg_ss_refclk960m>;
> >> +				clock-names =	"wkupclk",
> >> +						"sysclk",
> >> +						"refclk";
> >>  				#phy-cells = <0>;
> >>  			};
> >>  		};
> >> -- 
> >> 1.8.3.2
> >>
> > 
> 
