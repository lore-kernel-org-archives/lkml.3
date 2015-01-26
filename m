Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbbAZO1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:27:36 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:53482 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481AbbAZO1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:27:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
Cc: tiwai@suse.de, perex@perex.cz, broonie@kernel.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, lars@metafoo.de
Subject: Re: [PATCH_V2 2/4] dt: sound: jz4740: Add binding documentation for jz4740-i2s
Date: Mon, 26 Jan 2015 15:27:17 +0100
Message-ID: <5212689.3MTQUevMKn@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1422278138-51097-3-git-send-email-Zubair.Kakakhel@imgtec.com>
References: <1422278138-51097-1-git-send-email-Zubair.Kakakhel@imgtec.com> <1422278138-51097-3-git-send-email-Zubair.Kakakhel@imgtec.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:nXQQ7ds3aZOPhypjyKPw1sP1Ds/HMgmFs79ftyCk8NjgiJlizWS
 8AMF2dmCHtq+ExOO5fN8sG9FDxsR9IB4wP7xbmDSsI+sgrhS/66aTn0RXPJYh7KiRLDTSgj
 wVBgU/E1RaKRuG7XGnk7BoiUabLFJEMnrpz7RChrw5KLysE80olEFFZXuw3aXsuvlB1J9eL
 g/22UdEPBV/C3rMsyFvOQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 January 2015 13:15:36 Zubair Lutfullah Kakakhel wrote:
> +
> +Required properties:
> +- compatible : "ingenic,jz4740-i2s"
> +- reg : I2S registers location and length
> +- clocks : AIC and I2S PLL clock specifiers.
> +- clock-names: "aic" and "i2s"
> +
> +Example:
> +
> +i2s: i2s@10020000 {
> +       compatible = "ingenic,jz4740-i2s";
> +       reg = <0x10020000 0x94>;
> +
> +       clocks = <&cgu JZ4740_CLK_AIC>, <&cgu JZ4740_CLK_I2SPLL>;
> +       clock-names = "aic", "i2s";
> +
> +       dmas = <&dma 2>, <&dma 3>;
> +       dma-names = "tx", "rx";
> +
> 

Thanks for adding the dma entries to the example. Unfortunately you
have missed adding them to the list of required properties,
so please add those as well.

	Arnd
