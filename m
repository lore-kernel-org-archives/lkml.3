Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545AbaB0JcE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 04:32:04 -0500
Received: from mail-vc0-f170.google.com ([209.85.220.170]:56258 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbaB0JcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 04:32:00 -0500
MIME-Version: 1.0
In-Reply-To: <1393271698-15829-1-git-send-email-fabian@ritter-vogt.de>
References: <1393271698-15829-1-git-send-email-fabian@ritter-vogt.de>
Date: Thu, 27 Feb 2014 10:31:59 +0100
Message-ID: <CACRpkdZqAMMvHiGwVDNnZ7Lg9RUVtjFGdfnZF3+QrX0KRPVJGA@mail.gmail.com>
Subject: Re: [PATCH V6] gpio: New driver for LSI ZEVIO SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabian Vogt <fabian@ritter-vogt.de>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>, Rob Landley <rob@landley.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 8:54 PM, Fabian Vogt <fabian@ritter-vogt.de> wrote:

> This driver supports the GPIO controller found in LSI ZEVIO SoCs.
> It has been successfully tested on a TI nspire CX calculator.
>
> Signed-off-by: Fabian Vogt <fabian@ritter-vogt.de>

I like this version. Patch applied.

Q:

> +config GPIO_ZEVIO
> +       bool "LSI ZEVIO SoC memory mapped GPIOs"
> +       depends on OF

So OF_GPIO is not needed for the systems using this driver?
DT just used for probing the driver?

Yours,
Linus Walleij
