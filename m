Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab3GWFY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 01:24:27 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:36649 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab3GWFY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 01:24:26 -0400
MIME-Version: 1.0
In-Reply-To: <03c7d481b618386f577c64787f283c69956dd423.1374451988.git.joe@perches.com>
References: <cover.1374451988.git.joe@perches.com>
	<03c7d481b618386f577c64787f283c69956dd423.1374451988.git.joe@perches.com>
Date: Tue, 23 Jul 2013 14:24:25 +0900
X-Google-Sender-Auth: bB-kuh1MRMNX0HC7iprFjqknZzI
Message-ID: <CAH9JG2UOBb4nWfEqNd7xqp7urXjy0v9HCWo0AkspHGBe9G8rxw@mail.gmail.com>
Subject: Re: [PATCH 01/18] MAINTAINERS: EXYNOS - Remove board files
From: Kyungmin Park <kmpark@infradead.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Tomasz Figa <t.figa@samsung.com>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 9:15 AM, Joe Perches <joe@perches.com> wrote:
> ommit ca9143501c30 ("ARM: EXYNOS: Remove unused board files")
> removed the files, remove the patterns too.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> cc: Tomasz Figa <t.figa@samsung.com>
> cc: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> cc: Kukjin Kim <kgene.kim@samsung.com>
> ---
>  MAINTAINERS | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index bf61e04..2124104 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1154,8 +1154,6 @@ L:        linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  S:     Maintained
>  F:     arch/arm/mach-s5pv210/mach-aquila.c
>  F:     arch/arm/mach-s5pv210/mach-goni.c
> -F:     arch/arm/mach-exynos/mach-universal_c210.c
> -F:     arch/arm/mach-exynos/mach-nuri.c
>
>  ARM/SAMSUNG S5P SERIES 2D GRAPHICS ACCELERATION (G2D) SUPPORT
>  M:     Kyungmin Park <kyungmin.park@samsung.com>
> --
> 1.8.1.2.459.gbcd45b4.dirty
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
