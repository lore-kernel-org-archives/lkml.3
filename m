Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625AbaAHVcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 16:32:33 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:58163 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757331AbaAHVcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 16:32:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 6/9] mtd: nand: add sunxi NFC dt bindings doc
Date: Wed, 8 Jan 2014 22:28:55 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Boris BREZILLON <b.brezillon@overkiz.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, dev@linux-sunxi.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
References: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com> <1389190924-26226-7-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1389190924-26226-7-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201401082228.55807.arnd@arndb.de>
X-Provags-ID: V02:K0:4fv4X9FqfBNcTrFIS1rqemRf4ly6glBDQV0B3L1MBFl
 IJYopMHMj8L0Al84PyPgQqrIPl6Uf6bQCpBeOPoA679YbLUXLy
 juzFbcKTXMYIpdRU89dsxZ3l9m8MueRLb87SV1U7oF2JwmZz6O
 IGVFty+nexrnMpWm+DzYaCAvOKi/yLlTDQd50i6D7iNt6G9KN8
 mzE7atFW+vwv/0GHIymnGb8dacODu4rhBF/FtRtE2MVdmYsam4
 IRoqzuLgk89adnIlfKEPzvcfgLkM0pxWj6tVSFNrY1JOjcZgE3
 U2S3axmiQADgxX2AnhgXjBkf1z9VufVJgR54Rvi3tbRBuFBxlC
 I7NkWjB4ENL0xUk8n56I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 January 2014, Boris BREZILLON wrote:
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mtd/sunxi-nand.txt
> @@ -0,0 +1,71 @@
> +Allwinner NAND Flash Controller (NFC)
> +
> +Required properties:
> +- compatible : "allwinner,sun4i-nfc".
> +- reg : shall contain registers location and length for data and reg.
> +- interrupts : shall define the NFC interrupt.
> +- #address-cells: shall be set to 1. Encode the nand CS.
> +- #size-cells : shall be set to 0.
> +- clocks : shall reference NFC clocks.
> +- clock-names : NFC internal clock names. Shall contain :
> +    * "ahb_clk" : AHB gating clock
> +    * "sclk" : NFC clock
> +

One small request: Can we try to avoid the "NFC" name here? I think it's
too overloaded and people may confuse it with near-field communication,
which I'm sure will be supported in sunxi based devices at some point.

It doesn't hurt to also mention that the function block is called
nfc, but I think references to it are better named "nand", which is
less confusing.

	Arnd
