Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbbATKGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:06:41 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:47189 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbbATKGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:06:38 -0500
MIME-Version: 1.0
In-Reply-To: <1421581173-28416-2-git-send-email-ricardo.ribalda@gmail.com>
References: <1421581173-28416-1-git-send-email-ricardo.ribalda@gmail.com>
	<1421581173-28416-2-git-send-email-ricardo.ribalda@gmail.com>
Date: Tue, 20 Jan 2015 11:06:37 +0100
Message-ID: <CACRpkdbcYBZj1OLAbKJD8pChmBZoxvUwnCAPEJyehAVHqVCLdA@mail.gmail.com>
Subject: Re: [PATCH 1/8] gpio/mpc5200: Use of_mm_gpiochip_remove
From: Linus Walleij <linus.walleij@linaro.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 12:39 PM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:

> Since d621e8bae5ac9c67 (Create of_mm_gpiochip_remove), there is a
> counterpart for of_mm_gpiochip_add.
>
> This patch implements the remove function of the driver making use of
> it.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

OK nice stuff, patch applied.

Yours,
Linus Walleij
