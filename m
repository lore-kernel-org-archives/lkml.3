Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab3GAIM3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:12:29 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:33622 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab3GAIM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:12:27 -0400
Date: Mon, 1 Jul 2013 18:12:12 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68k/mac: Fix comment about iop_*_present flags setup
 timing
In-Reply-To: <1372586362-1206-1-git-send-email-geert@linux-m68k.org>
Message-ID: <alpine.LNX.2.00.1307011812050.9202@nippy.intranet>
References: <1372586362-1206-1-git-send-email-geert@linux-m68k.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 30 Jun 2013, Geert Uytterhoeven wrote:

> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  arch/m68k/mac/iop.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/m68k/mac/iop.c b/arch/m68k/mac/iop.c
> index 7d8d461..8a4c446 100644
> --- a/arch/m68k/mac/iop.c
> +++ b/arch/m68k/mac/iop.c
> @@ -118,9 +118,9 @@
>  
>  /*#define DEBUG_IOP*/
>  
> -/* Set to non-zero if the IOPs are present. Set by iop_init() */
> +/* Set to non-zero if the IOPs are present. Set by iop_preinit() */

I would write,

-/* Set to non-zero if the IOPs are present. Set by iop_init() */
+/* Non-zero if the IOPs are present */

Finn

