Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab3AUUrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 15:47:45 -0500
Received: from mail-ee0-f52.google.com ([74.125.83.52]:49312 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab3AUUrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 15:47:43 -0500
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Philip Avinash <avinashphilip@ti.com>
Cc: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, nsekhar@ti.com,
        linux-kernel@vger.kernel.org, gururaja.hebbar@ti.com,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: dts: AM33XX: Add ELM node
References: <1358491295-4022-1-git-send-email-avinashphilip@ti.com>
	<1358491295-4022-2-git-send-email-avinashphilip@ti.com>
Date: Mon, 21 Jan 2013 21:47:38 +0100
In-Reply-To: <1358491295-4022-2-git-send-email-avinashphilip@ti.com> (Philip
	Avinash's message of "Fri, 18 Jan 2013 12:11:33 +0530")
Message-ID: <877gn69sb9.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Philip" == Philip Avinash <avinashphilip@ti.com> writes:

 Philip> From: "Philip, Avinash" <avinashphilip@ti.com>
 Philip> Add ELM data node to AM33XX device tree file.

 Philip> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
 Philip> ---
 Philip>  arch/arm/boot/dts/am33xx.dtsi |    8 ++++++++
 Philip>  1 file changed, 8 insertions(+)

 Philip> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
 Philip> index c2f14e8..eaef5e7 100644
 Philip> --- a/arch/arm/boot/dts/am33xx.dtsi
 Philip> +++ b/arch/arm/boot/dts/am33xx.dtsi
 Philip> @@ -385,5 +385,13 @@
 Philip>  				mac-address = [ 00 00 00 00 00 00 ];
 Philip>  			};
 Philip>  		};
 Philip> +
 Philip> +		elm: elm@48080000 {
 Philip> +			compatible	= "ti,am33xx-elm";

Please drop the <tab> after compatible.

Other than that it looks goood.

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

-- 
Bye, Peter Korsgaard
