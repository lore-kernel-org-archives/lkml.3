Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744AbbANNSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 08:18:09 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:63006 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbbANNSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 08:18:06 -0500
MIME-Version: 1.0
In-Reply-To: <1421079651-2650-1-git-send-email-johan@kernel.org>
References: <1421079651-2650-1-git-send-email-johan@kernel.org>
Date: Wed, 14 Jan 2015 14:18:06 +0100
Message-ID: <CACRpkdb7=t5YXNTPv3xGUerKe62-dG+UJD9a7+Mz1aW5v_vMTA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: lantiq: remove bogus of_gpio_chip_add
From: Linus Walleij <linus.walleij@linaro.org>
To: Johan Hovold <johan@kernel.org>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 5:20 PM, Johan Hovold <johan@kernel.org> wrote:

> Remove bogus call to of_gpiochip_add (and of_gpio_chip remove in error
> path) which is also called when adding the gpio chip.
>
> This prevents adding the same pinctrl range twice.
>
> Fixes: 3f8c50c9b110 ("OF: pinctrl: MIPS: lantiq: implement lantiq/xway
> pinctrl support")
>
> Signed-off-by: Johan Hovold <johan@kernel.org>

Very weird. Patch applied.

Yours,
Linus Walleij
