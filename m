Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbaJXMXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 08:23:36 -0400
Received: from mail-qg0-f50.google.com ([209.85.192.50]:54614 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216AbaJXMXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:23:34 -0400
MIME-Version: 1.0
In-Reply-To: <12bd7950696ad30aa05348270df2e024ba113e63.1413488264.git.stefan@agner.ch>
References: <cover.1413488264.git.stefan@agner.ch>
	<12bd7950696ad30aa05348270df2e024ba113e63.1413488264.git.stefan@agner.ch>
Date: Fri, 24 Oct 2014 14:23:34 +0200
Message-ID: <CACRpkdZwtexz_85CPfhMWXj0=Xmo=7kuOh8BA9H8zBGdmshwEg@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] Documentation: dts: add bindings for Vybrid
 GPIO/PORT module
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

On Thu, Oct 16, 2014 at 9:48 PM, Stefan Agner <stefan@agner.ch> wrote:

> The Vybrid SoC device tree (vf610.dtsi) used this bindings since
> its initial commit in May 2013. However, a proper gpiolib driver
> was missing so far. With the addition of the gpiolib driver,
> the bindings proved to be useful and complete, hence a good time
> to add the documentation.
>
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> Acked-by: Shawn Guo <shawn.guo@freescale.com>

Patch applied to the GPIO tree.

Yours,
Linus Walleij
