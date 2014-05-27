Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666AbaE0N7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 09:59:15 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:60560 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaE0N7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 09:59:14 -0400
MIME-Version: 1.0
In-Reply-To: <8665687.jWqf6bo4lM@wuerfel>
References: <8665687.jWqf6bo4lM@wuerfel>
Date: Tue, 27 May 2014 15:59:13 +0200
Message-ID: <CACRpkdZH92Ps=9-zp-Xg_akq+=q2zGiiGaKzkAu16WqD24XF7A@mail.gmail.com>
Subject: Re: [PATCH] gpio: pch: include linux/slab.h
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jean Delvare <jdelvare@suse.de>, Alexandre Courbot <gnurou@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 5:04 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> The gpio-pch driver was recently enabled for compile-tests,
> which revealed that it is missing an include for linux/slab.h,
> which on ARM is not implied by any of the other headers.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Oh I fixed that up as I was going over the failed build logs.

Sorry that I didn't see this first, thanks anyway!

Yours,
Linus Walleij
