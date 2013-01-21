Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600Ab3AUWJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:09:13 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:44089 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab3AUWJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:09:12 -0500
MIME-Version: 1.0
In-Reply-To: <1358544639-14761-3-git-send-email-maxime.ripard@free-electrons.com>
References: <1358544639-14761-1-git-send-email-maxime.ripard@free-electrons.com>
	<1358544639-14761-3-git-send-email-maxime.ripard@free-electrons.com>
Date: Mon, 21 Jan 2013 23:09:07 +0100
Message-ID: <CACRpkdb8xLeP+RB+JfuEQu=MQ0yO6tVFasVrMsOE4FSfJHrOiw@mail.gmail.com>
Subject: Re: [PATCH 2/7] ARM: sunxi: Add pinctrl driver for Allwinner SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>, arm@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Stefan Roese <sr@denx.de>, Alejandro Mery <amery@geeks.cl>,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 10:30 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:
> The Allwinner SoCs have an IP module that handle both the muxing and the
> GPIOs.
>
> This IP has 8 banks of 32 bits, with a number of pins actually useful
> for each of these banks varying from one to another, and depending on
> the SoC used on the board.
>
> This driver only implements the pinctrl part, the gpio part will come
> eventually.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Patch title says "ARM: " but all changed except one line is to the pinctrl
tree so I have applied it to the pinctrl tree on a separate allwinner
branch for now (will merge it to devel when deemde stable).

ARM SoC boys: can I have an ACK on this oneliner?

Yours,
Linus Walleij
