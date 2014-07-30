Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097AbaG3HLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 03:11:20 -0400
Received: from aer-iport-2.cisco.com ([173.38.203.52]:26709 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880AbaG3HLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 03:11:19 -0400
X-IronPort-AV: E=Sophos;i="5.01,762,1400025600"; 
   d="scan'208";a="126431899"
Message-ID: <53D89846.60008@cisco.com>
Date: Wed, 30 Jul 2014 09:01:26 +0200
From: Hans Verkuil <hansverk@cisco.com>
Organization: Cisco Systems Norway
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>
CC: Hans Verkuil <hans.verkuil@cisco.com>, linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 3/6] MAINTAINERS: Update go7007 pattern
References: <cover.1406691397.git.joe@perches.com> <9532fa3e0e1bf8fd3f63a26e095060401d785648.1406691397.git.joe@perches.com>
In-Reply-To: <9532fa3e0e1bf8fd3f63a26e095060401d785648.1406691397.git.joe@perches.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Authenticated-User: hansverk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 05:38 AM, Joe Perches wrote:
> Commit 7955f03d18d1 ("[media] go7007: move out of staging into
> drivers/media/usb") moved the files, update the pattern.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> cc: Hans Verkuil <hans.verkuil@cisco.com>

Acked-By: Hans Verkuil <hans.verkuil@cisco.com>

Thanks, I forgot about that one.

I'll pull this in through our media subsystem repo.

	Hans

> ---
>  MAINTAINERS | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6033aaf..3960ba8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3997,6 +3997,12 @@ F:	Documentation/isdn/README.gigaset
>  F:	drivers/isdn/gigaset/
>  F:	include/uapi/linux/gigaset_dev.h
>  
> +GO7007 MPEG CODEC
> +M:	Hans Verkuil <hans.verkuil@cisco.com>
> +L:	linux-media@vger.kernel.org
> +S:	Maintained
> +F:	drivers/media/usb/go7007/
> +
>  GPIO SUBSYSTEM
>  M:	Linus Walleij <linus.walleij@linaro.org>
>  M:	Alexandre Courbot <gnurou@gmail.com>
> @@ -8603,11 +8609,6 @@ M:	Marek Belisko <marek.belisko@gmail.com>
>  S:	Odd Fixes
>  F:	drivers/staging/ft1000/
>  
> -STAGING - GO7007 MPEG CODEC
> -M:	Hans Verkuil <hans.verkuil@cisco.com>
> -S:	Maintained
> -F:	drivers/staging/media/go7007/
> -
>  STAGING - INDUSTRIAL IO
>  M:	Jonathan Cameron <jic23@kernel.org>
>  L:	linux-iio@vger.kernel.org
> 

