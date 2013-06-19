Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757498Ab3FSTGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 15:06:24 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:53066 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334Ab3FSTGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 15:06:22 -0400
MIME-Version: 1.0
In-Reply-To: <1371203869-16308-1-git-send-email-avinashphilipk@gmail.com>
References: <1371203869-16308-1-git-send-email-avinashphilipk@gmail.com>
Date: Wed, 19 Jun 2013 21:06:20 +0200
Message-ID: <CACRpkdaSTVgueBfvEt-C=f0tuem7BbuEdx-38HZPPJDGjtKELA@mail.gmail.com>
Subject: Re: [PATCH 0/2] Fix build breakage for tnetv107x platforms
From: Linus Walleij <linus.walleij@linaro.org>
To: Philip Avinash <avinashphilipk@gmail.com>
Cc: "Nori, Sekhar" <nsekhar@ti.com>,
        ext Kevin Hilman <khilman@deeprootsystems.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 11:57 AM, Philip Avinash
<avinashphilipk@gmail.com> wrote:

> tnetv107x_defconfig build failing on removal selection of NEED_MACH_GPIO_H
> for ARCH_DAVINCI. This is due to header files inclusion from mach/gpio-davinci.h
> So this patch series fixes the build breakage on removal of NEED_MACH_GPIO_H.
>
> This patch series is based on Linux 3.10-rc4 and is availabel at [1] and dependency on 2.
>
> 1. https://github.com/avinashphilip/am335x_linux/tree/linux_davinci_v3.10_soc_gpio_v310-rc4
> 2. https://patchwork.kernel.org/patch/97853/
>
> Philip Avinash (2):
>   ARM: davinci: fix for build breakage for tnetv107x platforms
>   gpio: gpio-tnetv107x: Fix bulid breakge

The series:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
