Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758178Ab3BGPgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 10:36:13 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:57161 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab3BGPgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 10:36:10 -0500
MIME-Version: 1.0
In-Reply-To: <1360148051-7560-16-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
	<1360148051-7560-16-git-send-email-lee.jones@linaro.org>
Date: Thu, 7 Feb 2013 16:36:03 +0100
Message-ID: <CACRpkdZH1YWfbxY8yEwZ=ko8GAbPG=3ejS1Rt_yUD9ZsXeZ5Dw@mail.gmail.com>
Subject: Re: [PATCH 15/49] ARM: ux500: Add supply for the L3G4200D Gyroscope
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Cc: linux-kernel@vger.kernel.org, broonie@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 11:53 AM, Lee Jones <lee.jones@linaro.org> wrote:

> This patch lists the L3G4200D Gyroscope as a consumer of the
> AB8500 VAUX1 regulator.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/mach-ux500/board-mop500-regulators.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
> index dbbeb20..097cf65 100644
> --- a/arch/arm/mach-ux500/board-mop500-regulators.c
> +++ b/arch/arm/mach-ux500/board-mop500-regulators.c
> @@ -73,6 +73,8 @@ static struct regulator_consumer_supply ab8500_vaux1_consumers[] = {
>         REGULATOR_SUPPLY("avdd", "3-005d"),
>         /* Synaptics RMI4 Touchscreen device */
>         REGULATOR_SUPPLY("vdd", "3-004b"),
> +       /* L3G4200D Gyroscope device */
> +       REGULATOR_SUPPLY("vdd", "l3g4200d"),

Hmmm isn't this an I2C device? Better check with Srinidhi about that
device name.

Yours,
Linus Walleij
