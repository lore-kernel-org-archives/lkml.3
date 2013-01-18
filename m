Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab3ARAzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 19:55:39 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:38950 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab3ARAzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 19:55:38 -0500
MIME-Version: 1.0
In-Reply-To: <1358391258-1771-59-git-send-email-keescook@chromium.org>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org> <1358391258-1771-59-git-send-email-keescook@chromium.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 17 Jan 2013 17:55:16 -0700
Message-ID: <CAErSpo71b+4ga6f+py3ZQtCCnVXNHbfxO-PBU28Uzcio-kwAvg@mail.gmail.com>
Subject: Re: [PATCH 58/86] drivers/pnp/pnpbios: remove depends on CONFIG_EXPERIMENTAL
To: Kees Cook <keescook@chromium.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: linux-kernel@vger.kernel.org, Adam Belay <abelay@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 7:53 PM, Kees Cook <keescook@chromium.org> wrote:
> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> while now and is almost always enabled by default. As agreed during the
> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
>
> CC: Adam Belay <abelay@mit.edu>
> CC: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Rafael, do you want to apply this?

> ---
>  drivers/pnp/pnpbios/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/pnp/pnpbios/Kconfig b/drivers/pnp/pnpbios/Kconfig
> index b986d9f..50c3dd0 100644
> --- a/drivers/pnp/pnpbios/Kconfig
> +++ b/drivers/pnp/pnpbios/Kconfig
> @@ -2,8 +2,8 @@
>  # Plug and Play BIOS configuration
>  #
>  config PNPBIOS
> -       bool "Plug and Play BIOS support (EXPERIMENTAL)"
> -       depends on ISA && X86 && EXPERIMENTAL
> +       bool "Plug and Play BIOS support"
> +       depends on ISA && X86
>         default n
>         ---help---
>           Linux uses the PNPBIOS as defined in "Plug and Play BIOS
> --
> 1.7.9.5
>
