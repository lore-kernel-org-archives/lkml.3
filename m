Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110AbaJ2IaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 04:30:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58775 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859AbaJ2IaL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 04:30:11 -0400
Message-ID: <5450A584.50504@ti.com>
Date: Wed, 29 Oct 2014 13:59:56 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Kevin Hilman <khilman@deeprootsystems.com>, <arm@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: drop list entry for davinci
References: <1414570806-12333-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1414570806-12333-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 October 2014 01:50 PM, Lad, Prabhakar wrote:
> As davinci-linux-open-source@linux.davincidsp.com is now
> shut and no more maintained by TI any more, drop the entry.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: Kevin Hilman <khilman@deeprootsystems.com>
> Cc: arm@kernel.org 
> ---
>  MAINTAINERS | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index dab92a7..48bffce 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8479,9 +8479,7 @@ F:	arch/arm/mach-s3c24xx/bast-irq.c
>  TI DAVINCI MACHINE SUPPORT
>  M:	Sekhar Nori <nsekhar@ti.com>
>  M:	Kevin Hilman <khilman@deeprootsystems.com>
> -L:	davinci-linux-open-source@linux.davincidsp.com (moderated for non-subscribers)
>  T:	git git://gitorious.org/linux-davinci/linux-davinci.git
> -Q:	http://patchwork.kernel.org/project/linux-davinci/list/

This is still valid. Please don't delete this.

Thanks,
Sekhar

