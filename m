Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab3GVXVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 19:21:13 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:44193 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab3GVXVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 19:21:04 -0400
MIME-Version: 1.0
In-Reply-To: <1374455781-17905-1-git-send-email-festevam@gmail.com>
References: <1374455781-17905-1-git-send-email-festevam@gmail.com>
Date: Tue, 23 Jul 2013 01:21:03 +0200
Message-ID: <CACRpkdbtkF17G6+7cHBg25dg6iwJuCGTMzuwWAKux6Z6_rBFPQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pinctrl-imx: Remove unneeded check for platform_get_resource()
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: Shawn Guo <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 3:16 AM, Fabio Estevam <festevam@gmail.com> wrote:

> From: Fabio Estevam <fabio.estevam@freescale.com>
>
> As devm_ioremap_resource() is used on probe, there is no need to explicitly
> check the return value from platform_get_resource(), as this is something that
> devm_ioremap_resource() takes care by itself.
>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Applied with Shawn's ACK.

Yours,
Linus Walleij
