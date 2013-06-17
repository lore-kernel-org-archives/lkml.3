Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab3FQFgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 01:36:06 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:64341 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab3FQFgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 01:36:04 -0400
MIME-Version: 1.0
In-Reply-To: <1370046121-7835-2-git-send-email-rvaswani@codeaurora.org>
References: <1370046121-7835-1-git-send-email-rvaswani@codeaurora.org>
	<1370046121-7835-2-git-send-email-rvaswani@codeaurora.org>
Date: Mon, 17 Jun 2013 07:36:02 +0200
Message-ID: <CACRpkdaMgp4jx6PRWydf-aMj5_0pbqmTtzWxfR4UJH-QG+sC9g@mail.gmail.com>
Subject: Re: [PATCH 1/3] ARM: msm: Remove gpiomux-v2 and re-organize
 MSM_GPIOMUX configs
From: Linus Walleij <linus.walleij@linaro.org>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 1, 2013 at 2:21 AM, Rohit Vaswani <rvaswani@codeaurora.org> wrote:

> Remove gpiomux-v2 as it's not being used and make way for future improvements.
>
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> ---
>  arch/arm/mach-msm/Kconfig        |   13 +++-----
>  arch/arm/mach-msm/Makefile       |    6 +--
>  arch/arm/mach-msm/gpiomux-8x60.c |   19 ------------
>  arch/arm/mach-msm/gpiomux-v2.c   |   25 ---------------
>  arch/arm/mach-msm/gpiomux-v2.h   |   61 --------------------------------------
>  arch/arm/mach-msm/gpiomux.c      |   15 +++++++++
>  arch/arm/mach-msm/gpiomux.h      |    5 ---
>  drivers/gpio/gpio-msm-v2.c       |    5 +--
>  8 files changed, 24 insertions(+), 125 deletions(-)
>  delete mode 100644 arch/arm/mach-msm/gpiomux-8x60.c
>  delete mode 100644 arch/arm/mach-msm/gpiomux-v2.c
>  delete mode 100644 arch/arm/mach-msm/gpiomux-v2.h

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
