Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbaJXMU1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 08:20:27 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:36781 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756091AbaJXMUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:20:25 -0400
MIME-Version: 1.0
In-Reply-To: <a6e91699b6bf7dc4e8293374bce7c05a0d40053c.1413488264.git.stefan@agner.ch>
References: <cover.1413488264.git.stefan@agner.ch>
	<a6e91699b6bf7dc4e8293374bce7c05a0d40053c.1413488264.git.stefan@agner.ch>
Date: Fri, 24 Oct 2014 14:20:24 +0200
Message-ID: <CACRpkdYh6gc+tGdXvhQeX-oTC_BK3n9cXetFbX+0XBRjAp9HPA@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] pinctrl: imx: add gpio pinmux support for vf610
From: Linus Walleij <linus.walleij@linaro.org>
To: Stefan Agner <stefan@agner.ch>
Cc: Alexandre Courbot <gnurou@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        bpringlemeir@nbsps.com, Lucas Stach <l.stach@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 9:47 PM, Stefan Agner <stefan@agner.ch> wrote:

> Add pinmux support for GPIO for Vybrid (vf610) IOMUX controller.
> This is needed since direction configuration is not part of the
> GPIO module in Vybrid.
>
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> Acked-by: Shawn Guo <shawn.guo@freescale.com>

Patch applied to the pin control tree.

Yours,
Linus Walleij
