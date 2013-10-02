Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab3JBVK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 17:10:57 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:52567 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab3JBVKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 17:10:55 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ben Dooks <ben-linux@fluff.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 2/5] gpio: samsung: Use CONFIG_ARCH_S3C64XX to check for S3C64xx support
Date: Wed, 02 Oct 2013 23:10:52 +0200
Message-ID: <3903161.Vxg4RcbQZc@flatron>
User-Agent: KMail/4.11.1 (Linux/3.11.1-gentoo; KDE/4.11.1; x86_64; ; )
In-Reply-To: <CACRpkdZXOGpTspPucd=d0=Ws9Ccx19h4UYTTdgZceoofhuq0Kw@mail.gmail.com>
References: <1380392497-27406-1-git-send-email-tomasz.figa@gmail.com> <1380392497-27406-2-git-send-email-tomasz.figa@gmail.com> <CACRpkdZXOGpTspPucd=d0=Ws9Ccx19h4UYTTdgZceoofhuq0Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wednesday 02 of October 2013 12:46:51 Linus Walleij wrote:
> On Sat, Sep 28, 2013 at 8:21 PM, Tomasz Figa <tomasz.figa@gmail.com> 
wrote:
> > Since CONFIG_PLAT_S3C64XX is going to be removed, this patch modifies
> > the gpio-samsung driver to use the proper way of checking for S3C64xx
> > support - CONFIG_ARCH_S3C64XX.
> > 
> > Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks.

> I assume that this will go through ARM SoC?

I think so.

Best regards,
Tomasz

