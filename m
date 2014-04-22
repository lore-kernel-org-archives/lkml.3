Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374AbaDVLvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:51:23 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:44321 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174AbaDVLvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:51:18 -0400
MIME-Version: 1.0
In-Reply-To: <1397137966-30818-8-git-send-email-boris.brezillon@free-electrons.com>
References: <1397137966-30818-1-git-send-email-boris.brezillon@free-electrons.com>
	<1397137966-30818-8-git-send-email-boris.brezillon@free-electrons.com>
Date: Tue, 22 Apr 2014 13:51:17 +0200
Message-ID: <CACRpkdYT9HvG6dOVOEnBSNhRt847tdCsAU6E_dZLdFQEHntpKg@mail.gmail.com>
Subject: Re: [PATCH v3 7/7] ARM: sunxi: update the default ARCH_NR_GPIO for
 sunxi arch
From: Linus Walleij <linus.walleij@linaro.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
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
        dev@linux-sunxi.org, Alexandre Courbot <gnurou@gmail.com>,
        "arm@kernel.org" <arm@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 3:52 PM, Boris BREZILLON
<boris.brezillon@free-electrons.com> wrote:

> The A31 SoC has PL and PM banks and thus increase the default ARCH_NR_GPIO.
>
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Patch applied, and grrrr we need to get rid of these static #gpios defines
in the long run.

ARM SoC folks: notice this hitting arch/arm/Kconfig, complain if it's
problematic.

Yours,
Linus Walleij
