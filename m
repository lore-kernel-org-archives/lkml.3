Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787Ab3ART0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:26:24 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:54648 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab3ART0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:26:23 -0500
MIME-Version: 1.0
In-Reply-To: <1357681398-23956-4-git-send-email-maxime.ripard@free-electrons.com>
References: <1357681398-23956-1-git-send-email-maxime.ripard@free-electrons.com>
	<1357681398-23956-4-git-send-email-maxime.ripard@free-electrons.com>
Date: Fri, 18 Jan 2013 20:26:23 +0100
Message-ID: <CACRpkdZAXeMU=HXf36C6+737+8+fYkfcxSZqYc=Wp095aboOUA@mail.gmail.com>
Subject: Re: [PATCH 3/7] ARM: pinctrl: sunxi: Add the pinctrl pin set for sun5i
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, Stefan Roese <sr@denx.de>,
        Alejandro Mery <amery@geeks.cl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 10:43 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> Since the Allwinner SoCs variants don't have the same set of pins to
> handle, we need to declare the pin ranges available.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
(...)
>  static struct of_device_id sunxi_pinctrl_match[] __devinitconst = {

I think __devinitconst is also deprecated.

> +       { .compatible = "allwinner,sun5i-a13-pinctrl", .data = (void *)&sun5i_a13_pinctrl_data },
>         {}
>  };
>  MODULE_DEVICE_TABLE(of, sunxi_pinctrl_match);

Aha so the match table is in the subdrivers, hm.... OK.

Yours,
Linus Walleij
