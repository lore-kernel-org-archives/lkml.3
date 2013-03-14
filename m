Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757342Ab3CNORn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:17:43 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:49945 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab3CNORm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:17:42 -0400
MIME-Version: 1.0
In-Reply-To: <1363268870.1335.75.camel@x61.thuisdomein>
References: <1363268870.1335.75.camel@x61.thuisdomein>
Date: Thu, 14 Mar 2013 10:17:41 -0400
Message-ID: <CA+5PVA6CzVZVDyQNzChddo7NV05EMgtqZw1xxBeA5oJzdqTLpA@mail.gmail.com>
Subject: Re: [PATCH] powerpc/40x: remove unused "config 405GPR"
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

On Thu, Mar 14, 2013 at 9:47 AM, Paul Bolle <pebolle@tiscali.nl> wrote:
> The last user of Kconfig symbol 405GPR got removed in release v3.2.
> Remove this symbol too.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Acked-by: Josh Boyer <jwboyer@gmail.com>

> ---
>  arch/powerpc/platforms/40x/Kconfig | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/arch/powerpc/platforms/40x/Kconfig b/arch/powerpc/platforms/40x/Kconfig
> index a392d12..7b7a77c 100644
> --- a/arch/powerpc/platforms/40x/Kconfig
> +++ b/arch/powerpc/platforms/40x/Kconfig
> @@ -119,9 +119,6 @@ config 405EZ
>         select IBM_EMAC_MAL_CLR_ICINTSTAT
>         select IBM_EMAC_MAL_COMMON_ERR
>
> -config 405GPR
> -       bool
> -
>  config XILINX_VIRTEX
>         bool
>         select DEFAULT_UIMAGE
> --
> 1.7.11.7
>
>
>
