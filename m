Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbaGDH77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:59:59 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:36230 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755788AbaGDH75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:59:57 -0400
Message-ID: <53B65EF9.7000109@imgtec.com>
Date: Fri, 4 Jul 2014 08:59:53 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, linux-metag <linux-metag@vger.kernel.org>
Subject: Re: [PATCH 12/16] MAINTAINERS: Remove METAG imgdafs pattern
References: <cover.1404425176.git.joe@perches.com> <ce8a84fb71e9eaaf832ca7f9674bd0e6b4a54daf.1404425176.git.joe@perches.com>
In-Reply-To: <ce8a84fb71e9eaaf832ca7f9674bd0e6b4a54daf.1404425176.git.joe@perches.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/14 23:07, Joe Perches wrote:
> This never made it into the kernel tree.
> Remove it.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> cc: James Hogan <james.hogan@imgtec.com>

Yeh, after v10 of the patches and no response since v6 I gave up trying.

Acked-by: James Hogan <james.hogan@imgtec.com>

Cheers
James

> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0df8ab5..f223d8f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5803,7 +5803,6 @@ F:	drivers/clocksource/metag_generic.c
>  F:	drivers/irqchip/irq-metag.c
>  F:	drivers/irqchip/irq-metag-ext.c
>  F:	drivers/tty/metag_da.c
> -F:	fs/imgdafs/
>  
>  MICROBLAZE ARCHITECTURE
>  M:	Michal Simek <monstr@monstr.eu>
> 
