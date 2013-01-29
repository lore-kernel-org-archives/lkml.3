Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769Ab3A2WiV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 17:38:21 -0500
Received: from mail-ia0-f170.google.com ([209.85.210.170]:33700 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3A2WiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 17:38:19 -0500
MIME-Version: 1.0
In-Reply-To: <1359405192-1192-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1359405192-1192-1-git-send-email-maxime.ripard@free-electrons.com>
Date: Tue, 29 Jan 2013 23:38:17 +0100
Message-ID: <CACRpkdaNz6szEu6v=C97MfUzQzM3rG1hGHtHdO-aWXLCgHQEeQ@mail.gmail.com>
Subject: Re: [PATCHv4] ARM: sunxi: gpio: Add Allwinner SoCs GPIO drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, Alejandro Mery <amery@geeks.cl>,
        Stefan Roese <sr@denx.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 9:33 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> The IP responsible for the muxing on the Allwinner SoCs are also
> handling the GPIOs on the system. This patch adds the needed driver that
> relies on the pinctrl driver for most of its operations.
>
> The number of pins available for GPIOs operations are already declared
> in the pinctrl driver, we only need to probe a generic driver to handle
> the banks available for each SoC.
>
> This driver has been tested on a A13-Olinuxino.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Applied to my allwinner branch.

I'm a bit confused with other patches floating around,
I hope I'm supposed to apply this first...

Thanks,
Linus Walleij
