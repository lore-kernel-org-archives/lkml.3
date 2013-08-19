Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab3HSCgi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 22:36:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495Ab3HSCgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 22:36:37 -0400
Message-ID: <1376879761.11104.23.camel@t520.redhat.com>
Subject: Re: [PATCH] arm64: wire in generic parport.h
From: Mark Salter <msalter@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Date: Sun, 18 Aug 2013 22:36:01 -0400
In-Reply-To: <CAMuHMdXfXAaNeCAhmxTQb007Um7AjqRdF2=85t1Po_63T7XT5w@mail.gmail.com>
References: <1376841688.11104.8.camel@t520.redhat.com>
	 <CAMuHMdXfXAaNeCAhmxTQb007Um7AjqRdF2=85t1Po_63T7XT5w@mail.gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-08-18 at 22:25 +0200, Geert Uytterhoeven wrote:
> On Sun, Aug 18, 2013 at 6:01 PM, Mark Salter <msalter@redhat.com> wrote:
> > The arm64 port doesn't provide a parport.h which causes a build failure
> > with some configurations:
> >
> >   drivers/parport/parport_pc.c:67:25: fatal error: asm/parport.h: No such file or directory
> >    #include <asm/parport.h>
> >
> > This patch wires in the generic parport.h for arm64.
> 
> Can arm64 have a PC-style parport?

Good question. I'm not sure, but really doubt it.

> 
> If not, you're better off disabling it in drivers/parport/Kconfig.
> 
> You will receive bonus points for introducing ARCH_MAY_HAVE_PC_PARPORT,
> cfr. ARCH_MAY_HAVE_PC_FDC.
> 

Yes, good point. I'll work up a new patch. I can use some bonus points.

--Mark


