Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab3HMNtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:49:05 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:61001 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757185Ab3HMNtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:49:03 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18XNWMrt6jqvcLISR1dgzwS7+qsDNU05NQ=
Date: Tue, 13 Aug 2013 09:48:50 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 7/9] ARM: dove: add PCIe controllers to SoC DT
Message-ID: <20130813134850.GZ25111@titan.lakedaemon.net>
References: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1376333215-12885-8-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130812200452.GW25111@titan.lakedaemon.net>
 <520A1871.4000501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520A1871.4000501@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 01:28:49PM +0200, Sebastian Hesselbarth wrote:
> On 08/12/13 22:04, Jason Cooper wrote:
> >On Mon, Aug 12, 2013 at 08:46:53PM +0200, Sebastian Hesselbarth wrote:
> >>This adds a node for the pcie controllers found on Dove SoCs to the
> >>SoC DT include.
> >>
> >>Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> >>---
> >>Cc: Russell King <linux@arm.linux.org.uk>
> >>Cc: Jason Cooper <jason@lakedaemon.net>
> >>Cc: Andrew Lunn <andrew@lunn.ch>
> >>Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> >>Cc: linux-kernel@vger.kernel.org
> >>Cc: linux-arm-kernel@lists.infradead.org
> >>---
> >>  arch/arm/boot/dts/dove.dtsi |   54 +++++++++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 54 insertions(+)
> >
> >patches 7-9 applied to mvebu/dove_mbus since the dependencies are
> >cleaner that way.
> 
> Jason,
> 
> I will have to slightly modify the reset-gpio property names and that
> requires a fixup patch for patch 8. Can you still squash it or do you
> need a proper patch?
...
> diff --git a/arch/arm/boot/dts/dove-d3plug.dts b/arch/arm/boot/dts/dove-d3plug.dts
> index ead90eb..f5f59bb 100644
> --- a/arch/arm/boot/dts/dove-d3plug.dts
> +++ b/arch/arm/boot/dts/dove-d3plug.dts
> @@ -91,7 +91,7 @@
>  	pcie-port@0 {
>  		status = "okay";
>  		reset-gpios = <&gpio0 26 1>;
> -		reset-delay-ms = <20>;
> +		reset-delay-us = <20000>;
>  		pinctrl-0 = <&pmx_camera_gpio>;
>  		pinctrl-names = "default";
>  	};

Squashed into 'ARM: dove: add initial DT file for Globalscale D3Plug' in
mvebu/dove_mbus-dt

thx,

Jason.

