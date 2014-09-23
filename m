Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557AbaIWNEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:04:05 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:55645 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383AbaIWNEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:04:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: "Hongzhou. Yang" <srv_hongzhou.yang@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Russell King <linux@arm.linux.org.uk>, srv_heupstream@mediatek.com,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Hongzhou Yang <hongzhou.yang@mediatek.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>, dandan.he@mediatek.com
Subject: Re: [PATCH v2 4/4] ARM: dts: mt8135: Add pinctrl node for mt8135.
Date: Tue, 23 Sep 2014 15:03:32 +0200
Message-ID: <2770365.r419rjIAOU@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411443545-24951-5-git-send-email-srv_hongzhou.yang@mediatek.com>
References: <1411443545-24951-1-git-send-email-srv_hongzhou.yang@mediatek.com> <1411443545-24951-5-git-send-email-srv_hongzhou.yang@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:rtPsa5g79XCP14lYvX11NGUv/0i9LAVUqz0Ty/YZzEZ
 K3YvJkof1WJUWu7kJkOcBtn6LNbJBs+kRKspNEfmocU+1UAEW7
 9+eSkRfXntDUTk1e4DOh1YPeNaYvf7K8IpWqruNde2lR4wc0qq
 i38oDfAyVv/cQfktiwoe1UKW5EFlOSpUino+vvwBhRlwIbBMsp
 50WhQP5aipzVjk6whBDWyeqoWWqO6gOUo88MpzlJqqnwBRbxPA
 JEdkxFa1TAWbrUHzcqhghKaF2lnHYrdnDG/kdrzyP6DPr2QMfE
 LOjYz7aPv2u6aPBz/581sL8FUkOSbY+TAJD6S6GY1sryQ85RJn
 IakqAyu9RdFYFOMp41CQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 11:39:05 Hongzhou. Yang wrote:
> +#define MT8135_PIN_0_MSDC0_DAT7__FUNC_GPIO0 (MT_PIN_NO(0) | 0)
> +#define MT8135_PIN_0_MSDC0_DAT7__FUNC_MSDC0_DAT7 (MT_PIN_NO(0) | 1)
> +#define MT8135_PIN_0_MSDC0_DAT7__FUNC_EINT49 (MT_PIN_NO(0) | 2)
> +#define MT8135_PIN_0_MSDC0_DAT7__FUNC_I2SOUT_DAT (MT_PIN_NO(0) | 3)
> +#define MT8135_PIN_0_MSDC0_DAT7__FUNC_DAC_DAT_OUT (MT_PIN_NO(0) | 4)
> +#define MT8135_PIN_0_MSDC0_DAT7__FUNC_PCM1_DO (MT_PIN_NO(0) | 5)
> +#define MT8135_PIN_0_MSDC0_DAT7__FUNC_SPI1_MO (MT_PIN_NO(0) | 6)
> +#define MT8135_PIN_0_MSDC0_DAT7__FUNC_NALE (MT_PIN_NO(0) | 7)
> +

This list looks like it just describes the hardware, I think it would
be better to put the values directly into the DT, rather than
using such macros.

	Arnd
