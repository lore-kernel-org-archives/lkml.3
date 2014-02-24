Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaBXMIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 07:08:49 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:64585 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbaBXMIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 07:08:47 -0500
MIME-Version: 1.0
In-Reply-To: <1392069908-22017-1-git-send-email-ddaney.cavm@gmail.com>
References: <1392069908-22017-1-git-send-email-ddaney.cavm@gmail.com>
Date: Mon, 24 Feb 2014 13:08:46 +0100
Message-ID: <CACRpkdaobDYg6KAEetu5dpp+6ksu7ptvQ+D9rn7jRH0H+bFFQA@mail.gmail.com>
Subject: Re: [PATCH] of/gpio: Define OF_GPIO_OPEN_DRAIN flag for Open Drain outputs.
From: Linus Walleij <linus.walleij@linaro.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 11:05 PM, David Daney <ddaney.cavm@gmail.com> wrote:

> From: David Daney <david.daney@cavium.com>
>
> When we have a GPIO pin connected to an open-drain network, we want a
> standard way of specifying this in the device tree.  So we choose bit
> 1 of the flag field to indicate open drain.

This is a good idea.

But the patch is missing two things:

- Add open source as well, as indicated.

- Add this definition to include/dt-bindings/gpio/gpio.h

- Add this *and* the missing active low property to the binding
  documentation in:
  Documentation/devicetree/bindings/gpio/gpio.txt
  (pls help with this!)

Yours,
Linus Walleij
