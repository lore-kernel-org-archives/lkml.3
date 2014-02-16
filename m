Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbaBPVQw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 16:16:52 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:49201 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753396AbaBPVQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 16:16:51 -0500
Message-ID: <1392585409.28866.94.camel@x220>
Subject: Re: [PATCH RFC] MAINTAINERS: Mark SuperH orphan
From: Paul Bolle <pebolle@tiscali.nl>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Paul Mundt <paul.mundt@gmail.com>, Magnus Damm <magnus.damm@gmail.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Date: Sun, 16 Feb 2014 22:16:49 +0100
In-Reply-To: <1392584137-24486-1-git-send-email-geert@linux-m68k.org>
References: <1392584137-24486-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2014 21:16:49.0880 (UTC) FILETIME=[67FF3D80:01CF2B5C]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-16 at 21:55 +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> 
> Paul Mundt's email address bounces regularly, and he hasn't taken any
> SuperH patches for about one year.
> 
> Suggested-by: Paul Bolle <pebolle@tiscali.nl>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
> ---
>  MAINTAINERS |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

I think Andrew prefers to add an entry in CREDITS when removing someone
from MAINTAINERS. As that is the courteous thing to do, I guess. 

> diff --git a/MAINTAINERS b/MAINTAINERS
> index b2cf5cfb4d29..2d294561ebdc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8372,12 +8372,10 @@ S:	Maintained
>  F:	drivers/net/ethernet/dlink/sundance.c
>  
>  SUPERH
> -M:	Paul Mundt <lethal@linux-sh.org>
>  L:	linux-sh@vger.kernel.org
>  W:	http://www.linux-sh.org
>  Q:	http://patchwork.kernel.org/project/linux-sh/list/
> -T:	git git://github.com/pmundt/linux-sh.git sh-latest
> -S:	Supported
> +S:	Orphan
>  F:	Documentation/sh/
>  F:	arch/sh/
>  F:	drivers/sh/


Paul Bolle

