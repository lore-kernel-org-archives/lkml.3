Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbaJTMDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:03:07 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:52044 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbaJTMDD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:03:03 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Subject: Re: [linux-sunxi] [PATCH v5 2/4] ARM: sunxi: dt: Add DT bindings documentation for SUNXI Security System
From: Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <1413728182-13569-3-git-send-email-clabbe.montjoie@gmail.com>
Date: Mon, 20 Oct 2014 14:02:59 +0200
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        "linux@arm.linux.org.uk King" <linux@arm.linux.org.uk>,
        herbert@gondor.apana.org.au, Miller Miller <davem@davemloft.net>,
        Grant Likely <grant.likely@linaro.org>, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, joe@perches.com, mchehab@osg.samsung.com,
        crope@iki.fi, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        LABBE Corentin <clabbe.montjoie@gmail.com>
Content-Transfer-Encoding: 7BIT
Message-Id: <EC763015-19F7-4F25-8694-B1F6798E3B7B@dominion.thruhere.net>
References: <1413728182-13569-1-git-send-email-clabbe.montjoie@gmail.com> <1413728182-13569-3-git-send-email-clabbe.montjoie@gmail.com>
To: linux-sunxi@googlegroups.com
X-Mailer: Apple Mail (2.1990.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Op 19 okt. 2014, om 16:16 heeft LABBE Corentin <clabbe.montjoie@gmail.com> het volgende geschreven:
> 
> This patch adds documentation for Device-Tree bindings for the Security System cryptographic accelerator driver.
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> ---
> Documentation/devicetree/bindings/crypto/sunxi-ss.txt | 9 +++++++++
> 1 file changed, 9 insertions(+)
> create mode 100644 Documentation/devicetree/bindings/crypto/sunxi-ss.txt
> 
> diff --git a/Documentation/devicetree/bindings/crypto/sunxi-ss.txt b/Documentation/devicetree/bindings/crypto/sunxi-ss.txt
> new file mode 100644
> index 0000000..a566803
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/sunxi-ss.txt
> @@ -0,0 +1,9 @@
> +* Allwinner Security System found on A20 SoC
> +
> +Required properties:
> +- compatible : Should be "allwinner,sun7i-a20-crypto".
> +- reg: Should contain the Security System register location and length.
> +- interrupts: Should contain the IRQ line for the Security System.
> +- clocks : A phandle to the functional clock node of the Security System module
> +- clock-names : Name of the functional clock, should be "ahb" and "mod".

It would be nice to have a copy/paste ready example node in here, like Boris did in "[PATCH v6 2/2] mtd: nand: add sunxi NFC dt bindings doc".

regards,

Koen