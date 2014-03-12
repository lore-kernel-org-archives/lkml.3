Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbaCLRvN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 13:51:13 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:57775 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752640AbaCLRvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 13:51:06 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18LqTWK3fUVRGHTi0XuM8RC
Date: Wed, 12 Mar 2014 10:50:58 -0700
From: Tony Lindgren <tony@atomide.com>
To: George Cherian <george.cherian@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-omap@vger.kernel.org, balbi@ti.com,
        rogerq@ti.com, kishon@ti.com, rob@landley.net, galak@codeaurora.org,
        ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
        pawel.moll@arm.com, robh+dt@kernel.org, anatol.pomozov@gmail.com,
        bcousson@baylibre.com
Subject: Re: [PATCH v3 0/5] Add USB nodes for am43xx epos and gp evm
Message-ID: <20140312175057.GE1996@atomide.com>
References: <1394193422-18242-1-git-send-email-george.cherian@ti.com>
 <531FE9AD.7050703@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531FE9AD.7050703@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* George Cherian <george.cherian@ti.com> [140311 22:02]:
> Hi Tony,
> 
> On 3/7/2014 5:26 PM, George Cherian wrote:
> >The patch series adds USB dt nodes for am43xx epos and gp evm
> >
> >Boot tested with  Benoit's for_3.15 + following patches
> >
> >https://patchwork.kernel.org/patch/3600821/
> >https://patchwork.kernel.org/patch/3600831/
> >https://patchwork.kernel.org/patch/3600851/
> >https://patchwork.kernel.org/patch/3600841/
> >
> >
> >Changes from v1 -> v2
> >	* Reorder "doc: Add "ti,am437x-dwc3" comaptible for dwc3 glue"
> >	* Address v1 coments on "ARM: dts: AM4372: Add USB nodes"
> >
> >Changes from v2 -> v3
> >	* Removed unwanted dwc3_1 and dwc3_2 nodes from am437x-gp-evm.dts
> >	  and am43x-epos-evm.dts
> >
> >George Cherian (5):
> >   doc: Add "ti,am437x-dwc3" comaptible for dwc3 glue
> >   ARM: dts: am43xx clock data
> >   ARM: dts: AM4372: Add USB nodes
> >   ARM: dts: am437x-gp-evm: Enable USB
> >   ARM: dts: am43x-epos-evm: Enable USB
> >
> >  Documentation/devicetree/bindings/usb/omap-usb.txt |  4 +-
> >  arch/arm/boot/dts/am4372.dtsi                      | 95 ++++++++++++++++++++++
> >  arch/arm/boot/dts/am437x-gp-evm.dts                | 18 ++++
> >  arch/arm/boot/dts/am43x-epos-evm.dts               | 18 ++++
> >  arch/arm/boot/dts/am43xx-clocks.dtsi               | 17 ++++
> >  5 files changed, 151 insertions(+), 1 deletion(-)
> Can you please take this series.
> The whole series Reviewed-by: Roger Quadros <rogerq@ti.com>

Hmm I only see ack from Roger on patch 3? 

Regards,

Tony
