Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032AbaAOJl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 04:41:28 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:55715 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaAOJlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 04:41:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gerardo Di Iorio <arete74@gmail.com>, dev@linux-sunxi.org,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: sunxi: change the AllWinner A1X to sunxi
Date: Wed, 15 Jan 2014 10:40:56 +0100
Message-ID: <3612364.BZBltgonI0@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <20140115091006.GF3377@lukather>
References: <20140109153404.GA21055@kvmhost> <20140115091006.GF3377@lukather>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:cc4f5Bb/zk2pjq1RPDhStrG+gJdMkasScpBNhRr11Fl
 VrK7nyrbHX8Kzb4qDz8g4n9XtTQLzlsb6Vt8VheGX9BTSjaHGK
 SOP+s3ZOz0g8/kxFwh4nNXVJU+8ZuItWi5jJbzzEd5rZqrRnUW
 vlA2ZutDkNtoLnwSoP7nk1iobGGFSHwMpb+N8WRA14gY8eQalm
 4XX7Q/tI+ByqPFR37dPn1EfmXUKzZhTYhMYlm8zPFf7MV7K6G0
 /L0CYEog7Gpv7lc14RhErF7A07GuBXssBr3BreGtqLXl59zRla
 fSu3tNgnklbuqHHXSnjw6s2XR4qNHf99srf371S02wR6Qx2epn
 splr0GpGKTYgTajvPtXQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 January 2014 10:10:06 Maxime Ripard wrote:
> On Thu, Jan 09, 2014 at 04:34:04PM +0100, Gerardo Di Iorio wrote:
> > Change the AllWinner A1X SOCs to Allwinner Sunxi SOCs
> > 
> > Signed-off-by: Gerardo Di Iorio <arete74@gmail.com>
> > ---
> >  arch/arm/mach-sunxi/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/mach-sunxi/Kconfig b/arch/arm/mach-sunxi/Kconfig
> > index 547004c..adb2574 100644
> > --- a/arch/arm/mach-sunxi/Kconfig
> > +++ b/arch/arm/mach-sunxi/Kconfig
> > @@ -1,5 +1,5 @@
> >  config ARCH_SUNXI
> > -       bool "Allwinner A1X SOCs" if ARCH_MULTI_V7
> > +       bool "Allwinner Sunxi SOCs" if ARCH_MULTI_V7
> 
> I wonder if the sunxi (apart the weird letter case) is actually
> needed. Maybe we can just put "Allwinner SoCs" (it would be great if
> you could fix the SoCs case too).

If you want to have exact naming, try to find something that excludes the
old Sun3i (F20) and earlier chips (unless someone is already planning
to work on them). Maybe also mention the "Boxchip" name, although that
seems to be falling out of use these days.

	Arnd

