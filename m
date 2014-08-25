Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbaHYRZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:25:20 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:56143 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaHYRZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:25:17 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18791SA5hFQJnWXBNnXNVJf
Date: Mon, 25 Aug 2014 10:25:07 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, Keerthy <j-keerthy@ti.com>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        devicetree@vger.kernel.org, Dave Gerlach <d-gerlach@ti.com>
Subject: Re: [PATCH 1/3] pinctrl: bindings: Add OMAP pinctrl binding
Message-ID: <20140825172506.GM17254@atomide.com>
References: <1408716062-26055-1-git-send-email-nm@ti.com>
 <1408716062-26055-2-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408716062-26055-2-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [140822 07:03]:
> Add basic skeleton of OMAP pinctrl bindings. This is compatible with
> pinctrl,single bindings and is meant purely as a reference point.
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>

Looks like you have ti,omap2420-padconf and ti,omap2430-padconf missing
but after adding those too:

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  .../bindings/pinctrl/ti,omap-pinctrl.txt           |    9 +++++++++
>  1 file changed, 9 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pinctrl/ti,omap-pinctrl.txt
> 
> diff --git a/Documentation/devicetree/bindings/pinctrl/ti,omap-pinctrl.txt b/Documentation/devicetree/bindings/pinctrl/ti,omap-pinctrl.txt
> new file mode 100644
> index 0000000..156d964
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pinctrl/ti,omap-pinctrl.txt
> @@ -0,0 +1,9 @@
> +OMAP Pinctrl definitions
> +
> +Required properties:
> +- compatible : Should be one of:
> +  "ti,omap3-padconf" - OMAP3 compatible pinctrl
> +  "ti,omap4-padconf" - OMAP4 compatible pinctrl
> +  "ti,omap5-padconf" - OMAP5 compatible pinctrl
> +
> +See Documentation/devicetree/bindings/pinctrl/pinctrl-single.txt for further details.
> -- 
> 1.7.9.5
> 
