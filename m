Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbbATKRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:17:54 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:40332 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbbATKRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:17:52 -0500
MIME-Version: 1.0
In-Reply-To: <1421581173-28416-9-git-send-email-ricardo.ribalda@gmail.com>
References: <1421581173-28416-1-git-send-email-ricardo.ribalda@gmail.com>
	<1421581173-28416-9-git-send-email-ricardo.ribalda@gmail.com>
Date: Tue, 20 Jan 2015 11:17:51 +0100
Message-ID: <CACRpkdZ+FYQveP-ervZ5NWv0NYeYmsTwpB0jXYyUFNK4TotNSQ@mail.gmail.com>
Subject: Re: [PATCH 8/8] gpio/mpc8xxx: Use of_mm_gpiochip_remove
From: Linus Walleij <linus.walleij@linaro.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Peter Korsgaard <jacmet@sunsite.dk>
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
> Cc: Peter Korsgaard <jacmet@sunsite.dk>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Waiting for a v2 addressing the issues pointed out by Peter on this
patch.

Yours,
Linus Walleij
