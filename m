Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757061AbaDWNyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:54:41 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:33776 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbaDWNyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:54:35 -0400
MIME-Version: 1.0
In-Reply-To: <201404221620.19519.arnd@arndb.de>
References: <1397137966-30818-1-git-send-email-boris.brezillon@free-electrons.com>
	<1397137966-30818-8-git-send-email-boris.brezillon@free-electrons.com>
	<CACRpkdYT9HvG6dOVOEnBSNhRt847tdCsAU6E_dZLdFQEHntpKg@mail.gmail.com>
	<201404221620.19519.arnd@arndb.de>
Date: Wed, 23 Apr 2014 15:54:35 +0200
Message-ID: <CACRpkdZAd5SqeCg7XsjXMbYxD+RoriV6x6YMR=59Aon=S7cDnA@mail.gmail.com>
Subject: Re: [PATCH v3 7/7] ARM: sunxi: update the default ARCH_NR_GPIO for
 sunxi arch
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>, Alexandre Courbot <gnurou@gmail.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        =?UTF-8?Q?Emilio_L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, Chen-Yu Tsai <wens@csie.org>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dev@linux-sunxi.org, "arm@kernel.org" <arm@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 4:20 PM, Arnd Bergmann <arnd@arndb.de> wrote:

>> Patch applied, and grrrr we need to get rid of these static #gpios defines
>> in the long run.
>
> Yes, that would be nice. I guess the gpio-descriptor framework should
> have solved this, but we can't move everything over to that soon, right?

Not really, it has to happen platform by platform.

I did consider putting all the GPIO descriptors into a radix and
use that internally in gpiolib, but that wasn't easy to do
when I tried it, maybe I just thought backwards.

I would appreciate if drivers for new archs like arm64 would
use only GPIO descriptors from day one. Also if new drivers
only apply a an entirely new machine even. They should just
use descriptors.

Yours,
Linus Walleij
