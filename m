Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab3G2PhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 11:37:03 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:60195 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3G2PhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 11:37:01 -0400
MIME-Version: 1.0
In-Reply-To: <1374697248-23401-1-git-send-email-sboyd@codeaurora.org>
References: <1374697248-23401-1-git-send-email-sboyd@codeaurora.org>
Date: Mon, 29 Jul 2013 17:37:00 +0200
Message-ID: <CACRpkdY+FSjs5_tVDo3OtbMjk1qq8XO=U1JudRvbSwqUOG536w@mail.gmail.com>
Subject: Re: [PATCH] gpio_msm: Fix build error due to missing err.h
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Tushar Behera <tushar.behera@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 10:20 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> drivers/gpio/gpio-msm-v1.c: In function 'gpio_msm_v1_probe':
> drivers/gpio/gpio-msm-v1.c:656:2:
> error: implicit declaration of function 'IS_ERR'
> [-Werror=implicit-function-declaration]
> drivers/gpio/gpio-msm-v1.c:657:3:
> error: implicit declaration of function 'PTR_ERR'
> [-Werror=implicit-function-declaration]
>
> This driver failed to compile after commit 68515bb
> (gpio_msm: Convert to use devm_ioremap_resource,
> 2013-06-10).
>
> Cc: Tushar Behera <tushar.behera@linaro.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Thanks, patch applied and queued for fixes.

Yours,
Linus Walleij
