Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab3ARMU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 07:20:56 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:44831 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755910Ab3ARMUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 07:20:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Adam Belay <abelay@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 58/86] drivers/pnp/pnpbios: remove depends on CONFIG_EXPERIMENTAL
Date: Fri, 18 Jan 2013 13:26:50 +0100
Message-ID: <6430440.OJO6URng2f@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAErSpo71b+4ga6f+py3ZQtCCnVXNHbfxO-PBU28Uzcio-kwAvg@mail.gmail.com>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org> <1358391258-1771-59-git-send-email-keescook@chromium.org> <CAErSpo71b+4ga6f+py3ZQtCCnVXNHbfxO-PBU28Uzcio-kwAvg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 17, 2013 05:55:16 PM Bjorn Helgaas wrote:
> On Wed, Jan 16, 2013 at 7:53 PM, Kees Cook <keescook@chromium.org> wrote:
> > The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> > while now and is almost always enabled by default. As agreed during the
> > Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
> >
> > CC: Adam Belay <abelay@mit.edu>
> > CC: Bjorn Helgaas <bhelgaas@google.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> Rafael, do you want to apply this?

Yes, I will take this one.

Thanks,
Rafael


> > ---
> >  drivers/pnp/pnpbios/Kconfig |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/pnp/pnpbios/Kconfig b/drivers/pnp/pnpbios/Kconfig
> > index b986d9f..50c3dd0 100644
> > --- a/drivers/pnp/pnpbios/Kconfig
> > +++ b/drivers/pnp/pnpbios/Kconfig
> > @@ -2,8 +2,8 @@
> >  # Plug and Play BIOS configuration
> >  #
> >  config PNPBIOS
> > -       bool "Plug and Play BIOS support (EXPERIMENTAL)"
> > -       depends on ISA && X86 && EXPERIMENTAL
> > +       bool "Plug and Play BIOS support"
> > +       depends on ISA && X86
> >         default n
> >         ---help---
> >           Linux uses the PNPBIOS as defined in "Plug and Play BIOS
> > --
> > 1.7.9.5
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
