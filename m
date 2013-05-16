Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab3EPQPV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 12:15:21 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:47049 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767Ab3EPQPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 12:15:17 -0400
MIME-Version: 1.0
In-Reply-To: <1368440169-29088-3-git-send-email-maxime.ripard@free-electrons.com>
References: <1368440169-29088-1-git-send-email-maxime.ripard@free-electrons.com>
	<1368440169-29088-3-git-send-email-maxime.ripard@free-electrons.com>
Date: Thu, 16 May 2013 11:15:16 -0500
Message-ID: <CAL_Jsq+R_3K4PyYsvq4qo11wEmQkHB2Q+dZm68jqcKn9rDmqLw@mail.gmail.com>
Subject: Re: [PATCH 2/4] ARM: highbank: remove the .map_io declaration
From: Rob Herring <robherring2@gmail.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 5:16 AM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> Now that the ARM core code calls debug_ll_io_init, we can remove it from
> the machine_desc declaration.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Acked-by: Rob Herring <rob.herring@calxeda.com>

> ---
>  arch/arm/mach-highbank/highbank.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/arm/mach-highbank/highbank.c b/arch/arm/mach-highbank/highbank.c
> index e7df2dd..dc5d6be 100644
> --- a/arch/arm/mach-highbank/highbank.c
> +++ b/arch/arm/mach-highbank/highbank.c
> @@ -176,7 +176,6 @@ static const char *highbank_match[] __initconst = {
>
>  DT_MACHINE_START(HIGHBANK, "Highbank")
>         .smp            = smp_ops(highbank_smp_ops),
> -       .map_io         = debug_ll_io_init,
>         .init_irq       = highbank_init_irq,
>         .init_time      = highbank_timer_init,
>         .init_machine   = highbank_init,
> --
> 1.8.1.2
>
