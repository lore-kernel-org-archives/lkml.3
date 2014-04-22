Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983AbaDVNLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:11:20 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:43875 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaDVNLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:11:17 -0400
MIME-Version: 1.0
In-Reply-To: <1397401745-4812-1-git-send-email-festevam@gmail.com>
References: <1397401745-4812-1-git-send-email-festevam@gmail.com>
Date: Tue, 22 Apr 2014 15:11:16 +0200
Message-ID: <CACRpkdZ9zz7gVqMriYxo8RNPGkQV2kds7rp6=PPQr8fXBQkOgA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pinctrl-imx: Print the mux_mode field in hex format
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: Shawn Guo <shawn.guo@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014 at 5:09 PM, Fabio Estevam <festevam@gmail.com> wrote:

> From: Fabio Estevam <fabio.estevam@freescale.com>
>
> With debug enabled we get better readability dumps of the mux_mode register if
> we use hexadecimal format instead:
>
> imx6sl-pinctrl 20e0000.iomuxc: MX6SL_PAD_FEC_REF_CLK: 0x10 0x0001b0a8
>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Patch applied with Shawn's ACK.

Yours,
Linus Walleij
