Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbaJWQ4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 12:56:24 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:41035 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500AbaJWQ4W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 12:56:22 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH 4/4] mm: cma: Use %pa to print physical addresses
In-Reply-To: <1414074828-4488-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Organization: http://mina86.com/
References: <1414074828-4488-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1414074828-4488-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141023:linux-sh@vger.kernel.org::wEzJntVXPi+L6Cjz:00000000000000000000000000000000000000MDJ
X-Hashcash: 1:20:141023:linux-kernel@vger.kernel.org::XNUM2Y087QD6oxrE:0000000000000000000000000000000001UNO
X-Hashcash: 1:20:141023:linux@arm.linux.org.uk::Wu+6mOJ6ZUEkTKXD:00000000000000000000000000000000000000013lI
X-Hashcash: 1:20:141023:linux-arm-kernel@lists.infradead.org::BjmZQUiLKNX7YS0Q:00000000000000000000000001GPD
X-Hashcash: 1:20:141023:laurent.pinchart@ideasonboard.com::j8p6nF6wuq0v8+dX:00000000000000000000000000002aiz
X-Hashcash: 1:20:141023:iamjoonsoo.kim@lge.com::cjuAr6OiBosa9dNZ:0000000000000000000000000000000000000005lux
X-Hashcash: 1:20:141023:linux-mm@kvack.org::C9jr+E7rGsDsry2f:0000000000000000000000000000000000000000000639+
X-Hashcash: 1:20:141023:m.szyprowski@samsung.com::nxqzL6+WVYiYWCd6:0000000000000000000000000000000000000DgAh
Date: Thu, 23 Oct 2014 18:56:15 +0200
Message-ID: <xa1th9yulo7k.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23 2014, Laurent Pinchart wrote:
> Casting physical addresses to unsigned long and using %lu truncates the
> values on systems where physical addresses are larger than 32 bits. Use
> %pa and get rid of the cast instead.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>  mm/cma.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/mm/cma.c b/mm/cma.c
> index b83597b..741c7ec 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -212,9 +212,8 @@ int __init cma_declare_contiguous(phys_addr_t base,
>  	phys_addr_t highmem_start = __pa(high_memory);
>  	int ret = 0;
>  
> -	pr_debug("%s(size %lx, base %08lx, limit %08lx alignment %08lx)\n",
> -		__func__, (unsigned long)size, (unsigned long)base,
> -		(unsigned long)limit, (unsigned long)alignment);
> +	pr_debug("%s(size %pa, base %pa, limit %pa alignment %pa)\n",
> +		__func__, &size, &base, &limit, &alignment);
>  
>  	if (cma_area_count == ARRAY_SIZE(cma_areas)) {
>  		pr_err("Not enough slots for CMA reserved regions!\n");
> @@ -257,8 +256,8 @@ int __init cma_declare_contiguous(phys_addr_t base,
>  	 */
>  	if (fixed && base < highmem_start && base + size > highmem_start) {
>  		ret = -EINVAL;
> -		pr_err("Region at %08lx defined on low/high memory boundary (%08lx)\n",
> -			(unsigned long)base, (unsigned long)highmem_start);
> +		pr_err("Region at %pa defined on low/high memory boundary (%pa)\n",
> +			&base, &highmem_start);
>  		goto err;
>  	}
>  
> @@ -316,8 +315,8 @@ int __init cma_declare_contiguous(phys_addr_t base,
>  	if (ret)
>  		goto err;
>  
> -	pr_info("Reserved %ld MiB at %08lx\n", (unsigned long)size / SZ_1M,
> -		(unsigned long)base);
> +	pr_info("Reserved %ld MiB at %pa\n", (unsigned long)size / SZ_1M,
> +		&base);
>  	return 0;
>  
>  err:
> -- 
> 2.0.4
>

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
