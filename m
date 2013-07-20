Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab3GTHCR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 03:02:17 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:54833 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab3GTHCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 03:02:16 -0400
MIME-Version: 1.0
In-Reply-To: <1374242333-6852-20-git-send-email-lee.jones@linaro.org>
References: <1374242333-6852-1-git-send-email-lee.jones@linaro.org>
	<1374242333-6852-20-git-send-email-lee.jones@linaro.org>
Date: Sat, 20 Jul 2013 12:32:15 +0530
X-Google-Sender-Auth: wECZn8RaBllV-_ArRwuLoanQAsU
Message-ID: <CAOh2x==EBzy6MMy0Jv1=VSAD7Kdw7=Jag8g4oz-kfRH0XafGaw@mail.gmail.com>
Subject: Re: [PATCH 20/22] ARM: ux500: Remove '0x's from Spear 300 DTS file
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 7:28 PM, Lee Jones <lee.jones@linaro.org> wrote:
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  arch/arm/boot/dts/spear300.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/spear300.dtsi b/arch/arm/boot/dts/spear300.dtsi
> index f79b3df..8970a4a 100644
> --- a/arch/arm/boot/dts/spear300.dtsi
> +++ b/arch/arm/boot/dts/spear300.dtsi
> @@ -52,7 +52,7 @@
>                         status = "disabled";
>                 };
>
> -               shirq: interrupt-controller@0x50000000 {
> +               shirq: interrupt-controller@50000000 {
>                         compatible = "st,spear300-shirq";
>                         reg = <0x50000000 0x1000>;
>                         interrupts = <28>;

Should Ux500 come in subject line? And please write Spear as
SPEAr.

Otherwise all three patches look fine.

Ackedy-by: Viresh Kumar <viresh.kumar@linaro.org>
