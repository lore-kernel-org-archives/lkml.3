Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab3K2IfX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 03:35:23 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:46350 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab3K2IfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 03:35:20 -0500
MIME-Version: 1.0
In-Reply-To: <1385048076-7875-3-git-send-email-grygorii.strashko@ti.com>
References: <1385048076-7875-1-git-send-email-grygorii.strashko@ti.com>
	<1385048076-7875-3-git-send-email-grygorii.strashko@ti.com>
Date: Fri, 29 Nov 2013 09:35:19 +0100
Message-ID: <CACRpkdbrtyBgMiQ-+J9O5JdfBo8vZLL1rY9F7p1X_rWbr54Qzg@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: introduce GPIO_DAVINCI kconfig option
From: Linus Walleij <linus.walleij@linaro.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>,
        "Nori, Sekhar" <nsekhar@ti.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 4:34 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:

> The compatible to Davinci GPIO HW block is used by other TI SoCs, like
> Keystone, where GPIO support is declared as optional.
>
> Hence, introduce GPIO_DAVINCI Kconfig option which will allow to enable
> Davinci GPIO driver for Keystone SoCs when needed. At same time, kept
> Davinci GPIO driver enabled for Davinci SoCs by default.
>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Sekhar, same comment here.

Yours,
Linus Walleij
