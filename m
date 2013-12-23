Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847Ab3LWR0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 12:26:51 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:56314 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab3LWR0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 12:26:49 -0500
MIME-Version: 1.0
In-Reply-To: <1387815830-8794-4-git-send-email-pawel.moll@arm.com>
References: <1387815830-8794-1-git-send-email-pawel.moll@arm.com>
	<1387815830-8794-4-git-send-email-pawel.moll@arm.com>
Date: Mon, 23 Dec 2013 18:26:49 +0100
Message-ID: <CACRpkdb4w26vuOtR1bAhQ6k=1uQx=np4WwoabvH8pOq8HK54=w@mail.gmail.com>
Subject: Re: [RFC 03/18] GPIO: gpio-generic: Add label to platform data
From: Linus Walleij <linus.walleij@linaro.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Jon Medhurst <tixy@linaro.org>, "arm@kernel.org" <arm@kernel.org>,
        Olof Johansson <olof@lixom.net>, Alexandre Courbot <gnurou@gmail.com>,
        Anton Vorontsov <anton@enomsg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 23, 2013 at 5:23 PM, Pawel Moll <pawel.moll@arm.com> wrote:

> When registering more than one platform device, it is
> useful to set the gpio chip label in the platform data.
>
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: Anton Vorontsov <anton@enomsg.org>

Good point. But what about also adding device tree support for
naming the chips while you're at it?

I imagine a generic gpiochip property in
Documentation/devicetree/bindings/gpio/gpio.txt

Yours,
Linus Walleij
