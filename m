Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab3IWSI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 14:08:56 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:44290 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab3IWSIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 14:08:55 -0400
MIME-Version: 1.0
In-Reply-To: <1379788789-19801-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1379788789-19801-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Date: Mon, 23 Sep 2013 20:01:18 +0200
Message-ID: <CACRpkdbipy4RwrxbbB5NUO=MkZ0+gJwXHVRZMb+Mc5e6WTYiaQ@mail.gmail.com>
Subject: Re: [PATCH v6] gpio: pcf857x: Add OF support
From: Linus Walleij <linus.walleij@linaro.org>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>, Archit Taneja <archit@ti.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Linux-OMAP <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 21, 2013 at 8:39 PM, Laurent Pinchart
<laurent.pinchart+renesas@ideasonboard.com> wrote:

> Add DT bindings for the pcf857x-compatible chips and parse the device
> tree node in the driver.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  .../devicetree/bindings/gpio/gpio-pcf857x.txt      | 71 ++++++++++++++++++++++
>  drivers/gpio/gpio-pcf857x.c                        | 44 +++++++++++---
>  2 files changed, 107 insertions(+), 8 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
>
> Changes since v5:
>
> - Renamed pin to line in the DT bindings documentation
> - Renamed pins-initial-states DT property to lines-initial-states

I can't see any problem with this so patch applied.

Yours,
Linus Walleij
