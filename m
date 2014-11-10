Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbaKJUbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:31:05 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:45168 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaKJUbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:31:02 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19srFMtmOhHNu57Y4p3NEz7
Date: Mon, 10 Nov 2014 12:30:17 -0800
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Update entry for omap related .dts files to
 cover new SoCs
Message-ID: <20141110203017.GT31454@atomide.com>
References: <1413901462-32181-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1413901462-32181-1-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [141021 07:25]:
> DRA7(including AM5x) and AM47x series are handled under OMAP umbrella.
> These SoC support and dts have been added since 3.14 kernel and Pull
> requests for these have come in from OMAP till date.
> 
> So just ensure that get_maintainers can pick up this list as well.

Applying this into omap-for-v3.18/fixes as we've seen some
patches not copied to linux-omap list.

Regards,

Tony
 
> Cc: Benoît Cousson <bcousson@baylibre.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: linux-omap@vger.kernel.org
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
>  MAINTAINERS |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a20df9b..e205bd2 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6585,6 +6585,9 @@ L:	devicetree@vger.kernel.org
>  S:	Maintained
>  F:	arch/arm/boot/dts/*omap*
>  F:	arch/arm/boot/dts/*am3*
> +F:	arch/arm/boot/dts/*am4*
> +F:	arch/arm/boot/dts/*am5*
> +F:	arch/arm/boot/dts/*dra7*
>  
>  OMAP CLOCK FRAMEWORK SUPPORT
>  M:	Paul Walmsley <paul@pwsan.com>
> -- 
> 1.7.9.5
> 
