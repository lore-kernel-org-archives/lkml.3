Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab3A2W5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 17:57:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:60797 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab3A2W5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 17:57:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 1/5] ARM: sunxi: Increase the number of GPIOs available
Date: Tue, 29 Jan 2013 22:57:30 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-1-generic; KDE/4.3.2; x86_64; ; )
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, Alejandro Mery <amery@geeks.cl>,
        Stefan Roese <sr@denx.de>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
References: <1359211016-24097-1-git-send-email-maxime.ripard@free-electrons.com> <1359211016-24097-2-git-send-email-maxime.ripard@free-electrons.com> <CACRpkdbZhS1APd6bFEnh9OLJEnNMgtFOCmW8vz1fVP3+yKy7LQ@mail.gmail.com>
In-Reply-To: <CACRpkdbZhS1APd6bFEnh9OLJEnNMgtFOCmW8vz1fVP3+yKy7LQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301292257.30588.arnd@arndb.de>
X-Provags-ID: V02:K0:NwivN88jYiv6yhAvjILb89YDJIKnZzeKFVWnQd1ep7y
 p3k4wBQGmY8UZWy/EQx8r45lVKXPjYIbwvfNawZ+kFE1xXClFS
 DHh5YsaBirZ33DCOQnst5dymAl26t11rOYm/y3FtAfMDwINPtl
 N1GecareJGeP1doEqxGfhtbht2kMHCKOQfGRDFCbnAm0nHNrfg
 2rHH+YZxrLsi3m/EcoxgYYuuqj1V3g4DpuWr1FKtqcBIUSg/fa
 USQQI8XNhNCDDAemsP/CFX4Zn8kSO+LmjFrF0BWR97IVVSQhN2
 jisrkPveO7X6t46q/diwwbmp0eLINDQWRIiiby6zOOOcpp54Ge
 DTYtI1PjjcS59Fw/h5zI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 January 2013, Linus Walleij wrote:
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -1632,7 +1632,7 @@ config ARCH_NR_GPIO
> >         default 355 if ARCH_U8500
> >         default 264 if MACH_H4700
> >         default 512 if SOC_OMAP5
> > -       default 288 if ARCH_VT8500
> > +       default 288 if ARCH_VT8500 || ARCH_SUNXI
> 
> Can I have an ACK from the ARM SoC maintainers on this?
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>

for the change. Maybe you could also do a second patch on top that
sorts the lines by descending numbers and adds a comment? I think
for any multiplatform kernel, we have to pick the largest number
required by any of the enabled platforms.
