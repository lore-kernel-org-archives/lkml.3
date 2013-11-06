Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab3KFVXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 16:23:07 -0500
Received: from mail-qe0-f48.google.com ([209.85.128.48]:45464 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756039Ab3KFVXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 16:23:06 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20131106211352.GA24006@www.outflux.net>
References: <20131106211352.GA24006@www.outflux.net>
Date: Wed, 6 Nov 2013 13:23:03 -0800
Message-ID: <CAOesGMiJFt0sP1tjsLogDh0n6CXtE3POUpFLPH=XoFQapbir8Q@mail.gmail.com>
Subject: Re: [PATCH] ARM: make OABI default to off
From: Olof Johansson <olof@lixom.net>
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 6, 2013 at 1:13 PM, Kees Cook <keescook@chromium.org> wrote:
> Given recent discussions about the lack of OABI in the wild, switch
> CONFIG_OABI_COMPAT to off-by-default to encourage more system builders
> to avoid it.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/arm/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 1ad6fb6c094d..4ace7f33e8a1 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1728,7 +1728,7 @@ config AEABI
>  config OABI_COMPAT
>         bool "Allow old ABI binaries to run with this kernel (EXPERIMENTAL)"
>         depends on AEABI && !THUMB2_KERNEL
> -       default y
> +       default n

Nit: "default n" is the default default. So you can just delete the
line instead.


-Olof
