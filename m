Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbaDOJTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 05:19:17 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:58276 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753800AbaDOJTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 05:19:09 -0400
Message-ID: <1397553547.1985.25.camel@x220>
Subject: Re: [PATCH 16/28] Remove GENERIC_HAS_IOMAP
From: Paul Bolle <pebolle@tiscali.nl>
To: Lennox Wu <lennox.wu@gmail.com>
Cc: Richard Weinberger <richard@nod.at>, Chen Liqin <liqin.linux@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 15 Apr 2014 11:19:07 +0200
In-Reply-To: <CAF0htA5xWQwkMqdp0_zz05DLJvyCOJZf-v1Rso20de5VWFmPTA@mail.gmail.com>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-17-git-send-email-richard@nod.at>
	 <CAF0htA5xWQwkMqdp0_zz05DLJvyCOJZf-v1Rso20de5VWFmPTA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Apr 2014 09:19:07.0498 (UTC) FILETIME=[C0C6B4A0:01CF588B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 10:24 +0800, Lennox Wu wrote:
> Thanks.
> 
> Acked-by: Lennox Wu <lennox.wu@gmail.com>

I don't think this oneliner is queued somewhere. Lennox, you're listed
as one of the score maintainers: could you perhaps queue this patch?


Paul Bolle

> 2014-02-10 2:47 GMT+08:00 Richard Weinberger <richard@nod.at>:
> > The symbol is an orphan, get rid of it.
> >
> > Signed-off-by: Richard Weinberger <richard@nod.at>
> > ---
> >  arch/score/Kconfig | 3 ---
> >  1 file changed, 3 deletions(-)
> >
> > diff --git a/arch/score/Kconfig b/arch/score/Kconfig
> > index c75d06a..c7a7b65 100644
> > --- a/arch/score/Kconfig
> > +++ b/arch/score/Kconfig
> > @@ -23,19 +23,16 @@ config ARCH_SCORE7
> >         bool "SCORE7 processor"
> >         select SYS_SUPPORTS_32BIT_KERNEL
> >         select CPU_SCORE7
> > -       select GENERIC_HAS_IOMAP
> >
> >  config MACH_SPCT6600
> >         bool "SPCT6600 series based machines"
> >         select SYS_SUPPORTS_32BIT_KERNEL
> >         select CPU_SCORE7
> > -       select GENERIC_HAS_IOMAP
> >
> >  config SCORE_SIM
> >         bool "Score simulator"
> >         select SYS_SUPPORTS_32BIT_KERNEL
> >         select CPU_SCORE7
> > -       select GENERIC_HAS_IOMAP
> >  endchoice
> >
> >  endmenu
> > --
> > 1.8.4.2

