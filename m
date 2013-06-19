Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965015Ab3FSSmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:42:54 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:47013 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964932Ab3FSSmt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:42:49 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Roger Quadros <rogerq@ti.com>
Cc: <stern@rowland.harvard.edu>, <tony@atomide.com>, <balbi@ti.com>,
        <ruslan.bilovol@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <b-cousson@ti.com>
Subject: Re: [RFC PATCH 5/6] ARM: dts: omap3beagle-xm: Add idle state pins for USB host
References: <1371650753-11452-1-git-send-email-rogerq@ti.com>
	<1371650753-11452-6-git-send-email-rogerq@ti.com>
Date: Wed, 19 Jun 2013 11:42:45 -0700
In-Reply-To: <1371650753-11452-6-git-send-email-rogerq@ti.com> (Roger
	Quadros's message of "Wed, 19 Jun 2013 17:05:52 +0300")
Message-ID: <87obb26ixm.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roger Quadros <rogerq@ti.com> writes:

> Add the Idle state pins for USB host and enable WAKEUP on
> DIR, DAT0-3, so that the PHY can wakeup the OMAP SoC from
> sleep on any USB activity (e.g. remote wakeup or connect/disconnect).
>
> CC: Benoît Cousson <b-cousson@ti.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>

This one doesn't apply...

> ---
>  arch/arm/boot/dts/omap3-beagle-xm.dts |   29 +++++++++++++++++++++++------
>  1 files changed, 23 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts b/arch/arm/boot/dts/omap3-beagle-xm.dts
> index d3808ed..f1d56c2 100644
> --- a/arch/arm/boot/dts/omap3-beagle-xm.dts
> +++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
> @@ -89,12 +89,7 @@
>  };
>  
>  &omap3_pmx_core {
> -	pinctrl-names = "default";
> -	pinctrl-0 = <
> -			&hsusbb2_pins
> -	>;
> -
> -	hsusbb2_pins: pinmux_hsusbb2_pins {

This omap3_pmx_core section doesn't exist upstream in the xM DTS file
(but does in omap3-beagle.dts.)  

Is there a dependency patch missing?

Kevin
