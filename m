Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab3FQPiD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:38:03 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:38437 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877Ab3FQPiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:38:00 -0400
Message-ID: <51BF2D52.2040000@samsung.com>
Date: Tue, 18 Jun 2013 00:37:54 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        linux-samsung-soc@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Joe Perches <joe@perches.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] MAINTAINERS: Add exynos filename match to ARM/S5P
 EXYNOS ARM ARCHITECTURES
References: <1371143144-31764-1-git-send-email-dianders@chromium.org> <1371421068-28743-1-git-send-email-dianders@chromium.org> <1371421068-28743-2-git-send-email-dianders@chromium.org>
In-Reply-To: <1371421068-28743-2-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/13 07:17, Doug Anderson wrote:
> This will help direct patches related to exynos to the
> linux-samsung-soc mailing list for discussion.
>
> Suggested by Joe Perches.
>
> Signed-off-by: Doug Anderson<dianders@chromium.org>

Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Thanks,
- Kukjin

> ---
> Changes in v2:
> - New for this version.
>
>   MAINTAINERS | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f55e3c7..2e95fd8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1140,6 +1140,7 @@ L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
>   S:	Maintained
>   F:	arch/arm/mach-s5p*/
>   F:	arch/arm/mach-exynos*/
> +N:	exynos
>
>   ARM/SAMSUNG MOBILE MACHINE SUPPORT
>   M:	Kyungmin Park<kyungmin.park@samsung.com>
