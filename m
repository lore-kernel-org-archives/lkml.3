Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763AbaJBRGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 13:06:40 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:46136 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaJBRGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 13:06:38 -0400
Date: Thu, 2 Oct 2014 19:05:19 +0200
From: Beniamino Galvani <b.galvani@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Victor Wan <victor.wan@amlogic.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Carlo Caione <carlo@caione.org>,
        Jerry Cao <jerry.cao@amlogic.com>
Subject: Re: [PATCH 1/6] ARM: meson: add meson8 machine definition
Message-ID: <20141002170519.GA29052@gmail.com>
References: <1412198986-26534-1-git-send-email-b.galvani@gmail.com>
 <1412198986-26534-2-git-send-email-b.galvani@gmail.com>
 <11073411.IcmTkIICYA@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11073411.IcmTkIICYA@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 11:24:54AM +0200, Arnd Bergmann wrote:
> On Wednesday 01 October 2014 23:29:41 Beniamino Galvani wrote:
> > 
> > +static const char * const m8_common_board_compat[] = {
> > +       "amlogic,meson8",
> > +       NULL,
> > +};
> > +
> >  DT_MACHINE_START(AML8726_MX, "Amlogic Meson6 platform")
> >         .dt_compat      = m6_common_board_compat,
> >  MACHINE_END
> >  
> > +DT_MACHINE_START(MESON8, "Amlogic Meson8 platform")
> > +       .dt_compat      = m8_common_board_compat,
> > +MACHINE_END
> > 
> 
> I'd just add the meson8 string to the m6_common_board_compat list and
> rename it.

>From what I've seen so far the two families are very similar and share
most of the IP cores, so a unique DT machine is a good idea.

Does the MACH_MESON8 Kconfig symbol still make sense or can I drop it
and rename MACH_MESON6 to MACH_MESON?

Beniamino

