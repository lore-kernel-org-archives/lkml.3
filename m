Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935551Ab3DHMOB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:14:01 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:52873 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760388Ab3DHMN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:13:59 -0400
MIME-Version: 1.0
In-Reply-To: <1365420434.1830.94.camel@x61.thuisdomein>
References: <1365420434.1830.94.camel@x61.thuisdomein>
Date: Mon, 8 Apr 2013 08:13:59 -0400
Message-ID: <CA+5PVA6B5Q8kEEUv4XohUWOjWGyEGhWFiJpe82hMfNiLVfV1sA@mail.gmail.com>
Subject: Re: [PATCH] powerpc: remove unused "config 405EP"
From: Josh Boyer <jwboyer@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Matt Porter <mporter@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 8, 2013 at 7:27 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> All users of Kconfig symbol 405EP were removed in release v2.6.27.
> Remove this symbol (and a useless select of it) too.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: Josh Boyer <jwboyer@gmail.com>

> ---
> 0) Tested by grepping the tree only.
>
> 1) There's also a Kconfig symbol EP405. Let's hope no one ever made a
> typo with either of these two symbols!
>
>  arch/powerpc/platforms/40x/Kconfig | 4 ----
>  1 file changed, 4 deletions(-)
>
> diff --git a/arch/powerpc/platforms/40x/Kconfig b/arch/powerpc/platforms/40x/Kconfig
> index 7b7a77c..bd40bbb 100644
> --- a/arch/powerpc/platforms/40x/Kconfig
> +++ b/arch/powerpc/platforms/40x/Kconfig
> @@ -20,7 +20,6 @@ config HOTFOOT
>          bool "Hotfoot"
>         depends on 40x
>         default n
> -       select 405EP
>         select PPC40x_SIMPLE
>         select PCI
>          help
> @@ -105,9 +104,6 @@ config 405GP
>         select IBM405_ERR51
>         select IBM_EMAC_ZMII
>
> -config 405EP
> -       bool
> -
>  config 405EX
>         bool
>         select IBM_EMAC_EMAC4
> --
> 1.7.11.7
>
