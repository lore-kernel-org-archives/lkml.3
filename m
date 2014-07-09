Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbaGIHs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 03:48:58 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:34762 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaGIHs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 03:48:57 -0400
MIME-Version: 1.0
In-Reply-To: <1404467529-26301-1-git-send-email-tushar.b@samsung.com>
References: <1404467529-26301-1-git-send-email-tushar.b@samsung.com>
Date: Wed, 9 Jul 2014 09:48:56 +0200
Message-ID: <CACRpkda4_yxOLJ=dhjuqjLqNyRwP=PnbdxWs14wrEakuM=ytjw@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: of: Update debug messages for of_get_named_gpiod_flags
From: Linus Walleij <linus.walleij@linaro.org>
To: Tushar Behera <tushar.b@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Tushar Behera <trblinux@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 4, 2014 at 11:52 AM, Tushar Behera <tushar.b@samsung.com> wrote:

> Following is the debug output (only a few examples) before and after the patch.
>
> $ dmesg | grep of_get_named_gpiod_flags
>
> Before:
> of_get_named_gpiod_flags: can't parse gpios property of node '/mmc@12220000[0]'
> of_get_named_gpiod_flags exited with status 0
>
> After:
> of_get_named_gpiod_flags: can't parse 'wp-gpios' property of node '/mmc@12220000[0]'
> of_get_named_gpiod_flags: parsed 'gpios' property of node '/gpio-keys/power[0]' - status (0)
>
> Signed-off-by: Tushar Behera <tushar.b@samsung.com>

Patch applied with Alexandre's ACK.

Yours,
Linus Walleij
