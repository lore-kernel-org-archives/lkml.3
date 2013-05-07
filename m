Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab3EGUAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 16:00:46 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:62968 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab3EGUAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 16:00:44 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F82E5C8EB@DQHE06.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F82E5C8EB@DQHE06.ent.ti.com>
Date: Tue, 7 May 2013 22:00:44 +0200
Message-ID: <CACRpkdZE5Q6Y7ZxEEz4SF3a1jiAqu8n0J+kWEyae_bUWmVE9Bw@mail.gmail.com>
Subject: Re: [PATCH 2/2] leds: lp5562: support the device tree feature
From: Linus Walleij <linus.walleij@linaro.org>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Bryan Wu <cooloney@gmail.com>,
        Gabriel Fernandez <gabriel.fernandez@stericsson.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 9:14 AM, Kim, Milo <Milo.Kim@ti.com> wrote:

> The LP55xx DT structure is applicable to the LP5562 device.
> The driver and documentation are updated.
>
> Compatible property of the DT
> : LP5521 and LP5223 were manufactured by National Semiconductor.
>   LP5562 is a new device from Texas Instruments.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Gabriel Fernandez <gabriel.fernandez@stericsson.com>
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
