Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932698Ab3FQL0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 07:26:01 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55000 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932447Ab3FQL0A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 07:26:00 -0400
MIME-Version: 1.0
In-Reply-To: <1371461892-5298-1-git-send-email-sachin.kamat@linaro.org>
References: <1371461892-5298-1-git-send-email-sachin.kamat@linaro.org>
Date: Mon, 17 Jun 2013 13:25:59 +0200
Message-ID: <CACRpkdaxpr_7minVkbwsMK+tpbEy7LChz5C+Gt7zYNYhee2ibw@mail.gmail.com>
Subject: Re: [PATCH Resend] pinctrl: exynos: Fix build breakage
From: Linus Walleij <linus.walleij@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>,
        Doug Anderson <dianders@chromium.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 11:38 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:

> 'exynos_wkup_irq_ack' should be defined ahead of its call.
>
> Fixes the following error:
> drivers/pinctrl/pinctrl-exynos.c: In function ‘exynos_wkup_irq_mask’:
> drivers/pinctrl/pinctrl-exynos.c:299:3: error: implicit declaration of
> function ‘exynos_wkup_irq_ack’ [-Werror=implicit-function-declaration]
>    exynos_wkup_irq_ack(irqd);
>
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> Cc: Doug Anderson <dianders@chromium.org>
> ---
> Fixed the commit message.
> ---

Applied.

Usually you should state which commit caused
the problem in the commit message.

Yours,
Linus Walleij
