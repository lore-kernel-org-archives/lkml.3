Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab3H2SaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:30:23 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:40975 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516Ab3H2SaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:30:18 -0400
MIME-Version: 1.0
In-Reply-To: <1377541133-7427-1-git-send-email-fabian@ritter-vogt.de>
References: <1377541133-7427-1-git-send-email-fabian@ritter-vogt.de>
Date: Thu, 29 Aug 2013 20:30:18 +0200
Message-ID: <CACRpkdbnvnCiJ1apWA4gq03QH-vhmKae_3yYjYxEqGzYsWjaqg@mail.gmail.com>
Subject: Re: [PATCH V5] gpio: New driver for LSI ZEVIO SoCs
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabian Vogt <fabian@ritter-vogt.de>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 8:18 PM, Fabian Vogt <fabian@ritter-vogt.de> wrote:

> This driver supports the GPIO controller found in LSI ZEVIO SoCs.
> It has been successfully tested on a TI nspire CX calculator.
> ---
>  .../devicetree/bindings/gpio/gpio-zevio.txt        |  15 ++
>  drivers/gpio/Kconfig                               |   6 +
>  drivers/gpio/Makefile                              |   1 +
>  drivers/gpio/gpio-zevio.c                          | 210 +++++++++++++++++++++
>  4 files changed, 232 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/gpio/gpio-zevio.txt
>  create mode 100644 drivers/gpio/gpio-zevio.c

Repeating what Stephen said, can you please provide a changelog?
I need an overview of what changed over time.

Yours,
Linus Walleij
