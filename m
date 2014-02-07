Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbaBGIsS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 03:48:18 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:41913 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaBGIsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 03:48:16 -0500
MIME-Version: 1.0
In-Reply-To: <1389094451-16628-1-git-send-email-p.zabel@pengutronix.de>
References: <1389094451-16628-1-git-send-email-p.zabel@pengutronix.de>
Date: Fri, 7 Feb 2014 09:48:16 +0100
Message-ID: <CACRpkdbHmUeh30Q_0VZ9UAbHXCMJxDu6rFSggQ9KJk8rjQsesg@mail.gmail.com>
Subject: Re: [RFC PATCH] gpiolib: make gpiod_direction_output take a logical
 value, add gpiod_direction_output_raw
From: Linus Walleij <linus.walleij@linaro.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>, Rob Landley <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 7, 2014 at 12:34 PM, Philipp Zabel <p.zabel@pengutronix.de> wrote:

> The documentation was not clear about whether gpio_direction_output should take
> a logical value or the physical level on the output line, i.e. whether the
> ACTIVE_LOW status would be taken into account.
> This converts gpiod_direction_output to use the logical level and adds a new
> gpiod_direction_output_raw for the raw value.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

OK we have consensus on this, patch applied for v3.15 with Alexandre's Review
tag.

Yours,
Linus Walleij
