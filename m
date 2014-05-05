Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbaEETX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 15:23:56 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:55181 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751802AbaEETXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 15:23:54 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+crylY0sOFya6LuVwVqx6v
Date: Mon, 5 May 2014 12:23:47 -0700
From: Tony Lindgren <tony@atomide.com>
To: George Cherian <george.cherian@ti.com>
Cc: balbi@ti.com, Benoit Cousson <bcousson@baylibre.org>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-omap@vger.kernel.org, rogerq@ti.com,
        kishon@ti.com, rob@landley.net, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, anatol.pomozov@gmail.com,
        bcousson@baylibre.com
Subject: Re: [PATCH v5 0/5] Add USB nodes for am43xx epos and gp evm
Message-ID: <20140505192346.GC15463@atomide.com>
References: <1395223803-4714-1-git-send-email-george.cherian@ti.com>
 <20140425161912.GY29632@saruman.home>
 <536745F6.9080402@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536745F6.9080402@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* George Cherian <george.cherian@ti.com> [140505 01:04]:
> Hi Benoit,
> 
> On 4/25/2014 9:49 PM, Felipe Balbi wrote:
> >On Wed, Mar 19, 2014 at 03:39:58PM +0530, George Cherian wrote:
> >>The patch series adds USB dt nodes for am43xx epos and gp evm
> >>Boot tested with linux-next + Tony's omap-for-v3.15/dt
> >>
> >>Changes from v1 -> v2
> >>	* Reorder "doc: Add "ti,am437x-dwc3" comaptible for dwc3 glue"
> >>	* Address v1 coments on "ARM: dts: AM4372: Add USB nodes"
> >>
> >>Changes from v2 -> v3
> >>	* Removed unwanted dwc3_1 and dwc3_2 nodes from am437x-gp-evm.dts
> >>	  and am43x-epos-evm.dts
> >>
> >>Changes from v3 -> v4
> >>	* Refreshed on top of Tony's omap-for-v3.15/dt tree
> >>	* Added usb_phy0_always_on_clk32k and usb_phy1_always_on_clk32k Patch 2
> >>	* Used the above clocks in Patch 3
> >>	* Patch 4 and 5 edited the unwanted portions of commit log
> >>
> >>Changes from v4 -> v5
> >>	* Address Roger's comment for the clock data
> >>
> >>George Cherian (5):
> >>   doc: Add "ti,am437x-dwc3" comaptible for dwc3 glue
> >>   ARM: dts: am43xx clock data
> >>   ARM: dts: AM4372: Add USB nodes
> >>   ARM: dts: am437x-gp-evm: Enable USB
> >>   ARM: dts: am43x-epos-evm: Enable USB
> >>
> >>  Documentation/devicetree/bindings/usb/omap-usb.txt |  4 +-
> >>  arch/arm/boot/dts/am4372.dtsi                      | 94 ++++++++++++++++++++++
> >>  arch/arm/boot/dts/am437x-gp-evm.dts                | 18 +++++
> >>  arch/arm/boot/dts/am43x-epos-evm.dts               | 18 +++++
> >>  arch/arm/boot/dts/am43xx-clocks.dtsi               | 32 ++++++++
> >>  5 files changed, 165 insertions(+), 1 deletion(-)
> >Is this applied anywhere yet ? Benoit, are you taking this for v3.16
> >merge window ?
> >
> Ping on this series.

Applying these into omap-for-v3.16/dt as I'm applying patches today.

Regards,

Tony
