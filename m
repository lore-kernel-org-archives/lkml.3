Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab3LKRzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 12:55:55 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:58181 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3LKRzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 12:55:50 -0500
MIME-Version: 1.0
In-Reply-To: <1385494815-15740-1-git-send-email-grygorii.strashko@ti.com>
References: <1385494815-15740-1-git-send-email-grygorii.strashko@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 11 Dec 2013 23:25:28 +0530
Message-ID: <CA+V-a8sY2XeXYco-a7jDrtnYm=_+Z1q05gw9Tr9RRZSU3Y=bDQ@mail.gmail.com>
Subject: Re: [RFC v1 0/9] gpio: davinci: reuse for keystone arch
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        dlos <davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grygorii,

Thanks for the patches.

On Wed, Nov 27, 2013 at 1:10 AM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
> This series is intended to update Davinci GPIO driver and reuse
> it for Keystone SoCs, because Keystone uses the similar GPIO IP like Davinci.
> Keystone GPIO IP: supports:
> - up to 32 GPIO lines;
> - only unbanked irqs;
>
> See Documentation:
> Keystone - http://www.ti.com/lit/ug/sprugv1/sprugv1.pdf
>
> [1] Depends on patch:
> "[PATCH 1/2] gpio: davinci: Fix a check for unbanked gpio"
> https://lkml.org/lkml/2013/11/8/22
>
> [2] and depends on series from Prabhakar Lad:
> "[PATCH v6 0/6] gpio: daVinci: cleanup and feature enhancement"
> https://www.mail-archive.com/devicetree@vger.kernel.org/msg05970.html
>
> Based on:
> git://git.kernel.org/pub/scm/linux/kernel/git/ssantosh/linux-keystone.git
> branch: keystone/master
>
> This series has been marked as RFC because it's based on an unfinished
> series of patches [2], but with hope that it will help to reach final decisions
> and satisfy all interested parties.
>
> Grygorii Strashko (9):
>   gpio: davinci: get rid of DAVINCI_N_GPIO
>   gpio: introduce GPIO_DAVINCI kconfig option
>   gpio: davinci: use chained_irq_enter/chained_irq_exit API
>   gpio: davinci: make IRQ initialization soc specific
>   gpio: davinci: reuse for Keystone SoC
>   arm: dts: keystone: add GPIO device entry
>   ARM: keystone_defconfig: enable gpio support
>   arm: dts: keystone-evm: add LEDs supports
>   ARM: keystone_defconfig: enable LED support
>
For patches 1, 2 and 3

Acked-and-tested-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad
