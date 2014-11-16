Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559AbaKPK6L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 05:58:11 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:63023 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099AbaKPK6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 05:58:08 -0500
MIME-Version: 1.0
In-Reply-To: <1416125020-5715-1-git-send-email-b.galvani@gmail.com>
References: <1416125020-5715-1-git-send-email-b.galvani@gmail.com>
Date: Sun, 16 Nov 2014 11:58:06 +0100
X-Google-Sender-Auth: Uu5q0QNBAgnwgtF3yABrThGdZYo
Message-ID: <CAOQ7t2Yyc-ZmHv=nqPztn9SNeKxCY6d1NEvnav+i04bO4nLE3Q@mail.gmail.com>
Subject: Re: [PATCH] clocksource: meson6: Select CLKSRC_MMIO
From: Carlo Caione <carlo@caione.org>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carlo Caione <carlo@caione.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2014 at 9:03 AM, Beniamino Galvani <b.galvani@gmail.com> wrote:
> Select CLKSRC_MMIO when the meson6_timer driver is enabled since it
> depends on clocksource MMIO functions.
>
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> ---
>  drivers/clocksource/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
> index 9042060..f657a48 100644
> --- a/drivers/clocksource/Kconfig
> +++ b/drivers/clocksource/Kconfig
> @@ -32,6 +32,7 @@ config ARMADA_370_XP_TIMER
>
>  config MESON6_TIMER
>         bool
> +       select CLKSRC_MMIO
>
>  config ORION_TIMER
>         select CLKSRC_OF
> --
> 1.9.1
>

Acked-by: Carlo Caione <carlo@caione.org>


-- 
Carlo Caione
