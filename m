Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453AbaJ3LZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:25:14 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:62560 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759157AbaJ3LZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:25:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Kevin Cernekee <cernekee@gmail.com>, f.fainelli@gmail.com,
        tglx@linutronix.de, jason@lakedaemon.net, ralf@linux-mips.org,
        lethal@linux-sh.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mbizon@freebox.fr, jogo@openwrt.org,
        linux-mips@linux-mips.org
Subject: Re: [PATCH V2 09/15] irqchip: Remove ARM dependency for bcm7120-l2 and brcmstb-l2
Date: Thu, 30 Oct 2014 12:24:59 +0100
Message-ID: <3334166.jta5WKHbUO@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54521CA6.1000802@cogentembedded.com>
References: <1414635488-14137-1-git-send-email-cernekee@gmail.com> <1414635488-14137-10-git-send-email-cernekee@gmail.com> <54521CA6.1000802@cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Vrq6N3YlcXBjZfZqqYy6wraeCXI6YqW8ZrpCtAiya5X
 V32ymQs1H8R54mAA/mn7nt3MK9f7vgYz1fY9Y5zlUggRJ8b0uV
 1CljUSGKqUcSogRqXx2rU5HrgsnuhgSo6u8O9PaWpSbqEcX08X
 GSIpyrJokEKrR3Nv3OZV6JFrnTIAuyjhdQ6SXH3kYDyw+RfF3f
 8n9793v+d3RJHcjYGMVMqmkC9ooUDXCdagjPCoE7wAYTVbZPEe
 muqbDm+JEzd7xTo2LfDw0ubVhHnQLDm2cYuytkz4/aI6i5mPBY
 zAFnjE7Nq4WiKy3jRefW2FpIrKltthOKltZTiFXh3y2sDK2WoK
 kOtxU6mwmkKB0jYITjvc=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 30 October 2014 14:10:30 Sergei Shtylyov wrote:
> > diff --git a/drivers/irqchip/Kconfig b/drivers/irqchip/Kconfig
> > index b21f12f..09c79d1 100644
> > --- a/drivers/irqchip/Kconfig
> > +++ b/drivers/irqchip/Kconfig
> > @@ -50,7 +50,6 @@ config ATMEL_AIC5_IRQ
> >
> >   config BRCMSTB_L2_IRQ
> >       bool
> > -     depends on ARM
> 
>     How about the following?
> 
>         depends on ARM || MIPS || COMPILE_TEST
> 

Makes no sense when the driver isn't user-selectable.

	Arnd
