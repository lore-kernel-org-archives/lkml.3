Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab3G0Sjf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 14:39:35 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:63938 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab3G0Sje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 14:39:34 -0400
MIME-Version: 1.0
In-Reply-To: <6062264246ae08acf8e4784bcff5814ebce4a620.1374451989.git.joe@perches.com>
References: <cover.1374451988.git.joe@perches.com>
	<6062264246ae08acf8e4784bcff5814ebce4a620.1374451989.git.joe@perches.com>
Date: Sat, 27 Jul 2013 14:39:33 -0400
Message-ID: <CAC-25o-_Woqz7G69eiB_PF6dhuoCRpy4VAwfocZ=tdcPXXP0=g@mail.gmail.com>
Subject: Re: [PATCH 11/18] MAINTAINERS: SI4713: Fix file pattern
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 21, 2013 at 8:15 PM, Joe Perches <joe@perches.com> wrote:
> commit c937ca034a0 ("[media] MAINTAINERS: Add maintainer entry for
> si4713 FM transmitter driver") typoed the pattern, fix it.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> cc: Eduardo Valentin <edubezval@gmail.com>

Acked-by: Eduardo Valentin <edubezval@gmail.com>

> cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 81d68ae..aa5ccd0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7394,7 +7394,7 @@ L:        linux-media@vger.kernel.org
>  T:     git git://linuxtv.org/media_tree.git
>  W:     http://linuxtv.org
>  S:     Odd Fixes
> -F:     drivers/media/radio/radio-si4713.h
> +F:     drivers/media/radio/radio-si4713.c
>
>  SIANO DVB DRIVER
>  M:     Mauro Carvalho Chehab <m.chehab@samsung.com>
> --
> 1.8.1.2.459.gbcd45b4.dirty
>



-- 
Eduardo Bezerra Valentin
