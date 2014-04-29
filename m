Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430AbaD2Uoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 16:44:55 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:58597 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757898AbaD2Uox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 16:44:53 -0400
MIME-Version: 1.0
In-Reply-To: <1398789430-23897-1-git-send-email-p.zabel@pengutronix.de>
References: <1398789430-23897-1-git-send-email-p.zabel@pengutronix.de>
Date: Tue, 29 Apr 2014 15:44:53 -0500
Message-ID: <CAL_JsqJLhino_s+BhiApRYBtbUvyrn4KF0Zax7YKP_HYLye5gw@mail.gmail.com>
Subject: Re: [PATCH 1/3] of: Add vendor prefix for Linear Technology Corporation
From: Rob Herring <robherring2@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 11:37 AM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Add Linear Technology Corporation to the list of device tree vendor prefixes.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index 0f01c9b..3d27991 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -65,6 +65,7 @@ lantiq        Lantiq Semiconductor
>  lg     LG Corporation
>  linux  Linux-specific binding
>  lsi    LSI Corp. (LSI Logic)
> +ltc    Linear Technology Corporation


Following the use of stock symbols, this should be lltc. Is this already in use?

Rob


>  marvell        Marvell Technology Group Ltd.
>  maxim  Maxim Integrated Products
>  microchip      Microchip Technology Inc.
> --
> 1.9.1
>
