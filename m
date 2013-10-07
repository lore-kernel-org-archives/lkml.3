Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab3JGTUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 15:20:16 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:34545 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab3JGTUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 15:20:13 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18bOAADYlpXHWaPDXVQBIzD
Date: Mon, 7 Oct 2013 12:20:09 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Felipe <balbi@ti.com>, Olof Johansson <olof@lixom.net>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] ARM: dts: omap3-beagle: use 3630 definitions
Message-ID: <20131007192009.GA8949@atomide.com>
References: <523C9D8B.2000701@ti.com>
 <1381164584-4008-1-git-send-email-nm@ti.com>
 <1381164584-4008-3-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381164584-4008-3-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [131007 09:57]:
> beagle-xm currently would matchup with ti,omap3 which invokes
> omap3430_init_early instead of omap3630_init_early. So add
> compatiblity for 3630 to allow match
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
>  arch/arm/boot/dts/omap3-beagle-xm.dts |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts b/arch/arm/boot/dts/omap3-beagle-xm.dts
> index 0f7cfc5..2079e22 100644
> --- a/arch/arm/boot/dts/omap3-beagle-xm.dts
> +++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
> @@ -11,7 +11,7 @@
>  
>  / {
>  	model = "TI OMAP3 BeagleBoard xM";
> -	compatible = "ti,omap3-beagle-xm", "ti,omap3-beagle", "ti,omap3";
> +	compatible = "ti,omap3-beagle-xm", "ti,omap363x", "ti,omap3-beagle", "ti,omap3";
>  
>  	cpus {
>  		cpu@0 {

This compatible string looks hacky.. How about just make it

"ti,omap3-beagle-xm", "ti,omap363x", "ti,omap3";

How about just leave out "ti,omap3-beagle" here?

And I would fold this change into the fix part of your first
patch in this series.

Regards,

Tony
