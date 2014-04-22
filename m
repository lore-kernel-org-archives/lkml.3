Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679AbaDVOVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 10:21:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.130]:61868 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaDVOVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 10:21:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v3 7/7] ARM: sunxi: update the default ARCH_NR_GPIO for sunxi arch
Date: Tue, 22 Apr 2014 16:20:19 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Emilio =?utf-8?q?L=C3=B3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, "Chen-Yu Tsai" <wens@csie.org>,
        Hans de Goede <hdegoede@redhat.com>, Shuge <shuge@allwinnertech.com>,
        kevin@allwinnertech.com,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dev@linux-sunxi.org, Alexandre Courbot <gnurou@gmail.com>,
        "arm@kernel.org" <arm@kernel.org>
References: <1397137966-30818-1-git-send-email-boris.brezillon@free-electrons.com> <1397137966-30818-8-git-send-email-boris.brezillon@free-electrons.com> <CACRpkdYT9HvG6dOVOEnBSNhRt847tdCsAU6E_dZLdFQEHntpKg@mail.gmail.com>
In-Reply-To: <CACRpkdYT9HvG6dOVOEnBSNhRt847tdCsAU6E_dZLdFQEHntpKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201404221620.19519.arnd@arndb.de>
X-Provags-ID: V02:K0:djmMHYvd3BJjyr56QGVZQfhASQykkOB/W60Pzp9VIHz
 jwNa22E+mXMdDp5MshiD0O//Vmy4dEMyrnKFmpkHtrN4dT7GJq
 ms/L9c3deRxxmPYqIjNX+OvrfU+2GxzK4jMEJ1j9nXwBfmOuwO
 ZxTN+0TPHc0x55xB0wLtjanfUtood2l/vEepx1aAWqXlmFaEsC
 frppHRR1s9ySxt1T3Nz80gQxlluZX3h0C0lcnVTuuWVJGQRNGY
 vCsaBCZYQJiG6EjY4GnytvNEPMFz0SD/azU0puPg4zUS/5Dx7b
 EIzyOgStdWzp0/yp6glYzJ0b7J7PiMr1n0177WQKqxmx89yyt+
 XZCy6rSb7mufVVutjQCs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 April 2014, Linus Walleij wrote:
> On Thu, Apr 10, 2014 at 3:52 PM, Boris BREZILLON
> <boris.brezillon@free-electrons.com> wrote:
> 
> > The A31 SoC has PL and PM banks and thus increase the default ARCH_NR_GPIO.
> >
> > Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> 
> Patch applied, and grrrr we need to get rid of these static #gpios defines
> in the long run.

Yes, that would be nice. I guess the gpio-descriptor framework should
have solved this, but we can't move everything over to that soon, right?

> ARM SoC folks: notice this hitting arch/arm/Kconfig, complain if it's
> problematic.

Thanks for letting us know about it.

	Arnd
