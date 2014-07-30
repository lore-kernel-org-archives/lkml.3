Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbaG3HMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 03:12:12 -0400
Received: from aer-iport-1.cisco.com ([173.38.203.51]:35238 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208AbaG3HML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 03:12:11 -0400
X-IronPort-AV: E=Sophos;i="5.01,762,1400025600"; 
   d="scan'208";a="127086690"
Message-ID: <53D8987F.1020304@cisco.com>
Date: Wed, 30 Jul 2014 09:02:23 +0200
From: Hans Verkuil <hansverk@cisco.com>
Organization: Cisco Systems Norway
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>
CC: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] MAINTAINERS: Update solo6x10 patterns
References: <cover.1406691397.git.joe@perches.com> <7142cc450c37b75474780f2e4610d5a44a0f757b.1406691397.git.joe@perches.com>
In-Reply-To: <7142cc450c37b75474780f2e4610d5a44a0f757b.1406691397.git.joe@perches.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Authenticated-User: hansverk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 05:38 AM, Joe Perches wrote:
> commit 28cae868cd24 ("[media] solo6x10: move out of staging into
> drivers/media/pci") moved the files, update the patterns.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
> cc: Hans Verkuil <hans.verkuil@cisco.com>

Acked-By: Hans Verkuil <hans.verkuil@cisco.com>

I'll pull this one in through our linux-media repo.

Thanks,

	Hans

> ---
>  MAINTAINERS | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3960ba8..8ed337c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8403,6 +8403,12 @@ M:	Chris Boot <bootc@bootc.net>
>  S:	Maintained
>  F:	drivers/leds/leds-net48xx.c
>  
> +SOFTLOGIC 6x10 MPEG CODEC
> +M:	Ismael Luceno <ismael.luceno@corp.bluecherry.net>
> +L:	linux-media@vger.kernel.org
> +S:	Supported
> +F:	drivers/media/pci/solo6x10/
> +
>  SOFTWARE RAID (Multiple Disks) SUPPORT
>  M:	Neil Brown <neilb@suse.de>
>  L:	linux-raid@vger.kernel.org
> @@ -8666,11 +8672,6 @@ M:	Christopher Harrer <charrer@alacritech.com>
>  S:	Odd Fixes
>  F:	drivers/staging/slicoss/
>  
> -STAGING - SOFTLOGIC 6x10 MPEG CODEC
> -M:	Ismael Luceno <ismael.luceno@corp.bluecherry.net>
> -S:	Supported
> -F:	drivers/staging/media/solo6x10/
> -
>  STAGING - SPEAKUP CONSOLE SPEECH DRIVER
>  M:	William Hubbs <w.d.hubbs@gmail.com>
>  M:	Chris Brannon <chris@the-brannons.com>
> 

