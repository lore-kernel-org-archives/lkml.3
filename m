Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbaGHAha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:37:30 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:36203 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbaGHAhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 20:37:24 -0400
MIME-Version: 1.0
In-Reply-To: <f40e93b943b749628d4012812a76e547384ea267.1404425176.git.joe@perches.com>
References: <cover.1404425176.git.joe@perches.com>
	<f40e93b943b749628d4012812a76e547384ea267.1404425176.git.joe@perches.com>
Date: Mon, 7 Jul 2014 17:37:23 -0700
Message-ID: <CAFECyb8xPhC_sjQQ8VepNqXV7gUaE0zSXr9keRZGmRSmq2C8Aw@mail.gmail.com>
Subject: Re: [PATCH 03/16] MAINTAINERS: Use the correct efi-stub location
From: Roy Franz <roy.franz@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 3, 2014 at 3:07 PM, Joe Perches <joe@perches.com> wrote:
> commit 4171fe2f8a47 ("EFI stub documentation updates") moved
> the file, update the pattern.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> cc: Roy Franz <roy.franz@linaro.org>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a047941..e3531a5 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3362,7 +3362,7 @@ M:        Matt Fleming <matt.fleming@intel.com>
>  L:     linux-efi@vger.kernel.org
>  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git
>  S:     Maintained
> -F:     Documentation/x86/efi-stub.txt
> +F:     Documentation/efi-stub.txt
>  F:     arch/ia64/kernel/efi.c
>  F:     arch/x86/boot/compressed/eboot.[ch]
>  F:     arch/x86/include/asm/efi.h
> --
> 1.8.1.2.459.gbcd45b4.dirty
>
Acked-by: Roy Franz <roy.franz@linaro.org>
