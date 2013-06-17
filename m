Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab3FQDfz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 23:35:55 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:41297 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab3FQDfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 23:35:54 -0400
MIME-Version: 1.0
In-Reply-To: <1371421068-28743-1-git-send-email-dianders@chromium.org>
References: <1371143144-31764-1-git-send-email-dianders@chromium.org>
	<1371421068-28743-1-git-send-email-dianders@chromium.org>
Date: Mon, 17 Jun 2013 12:35:52 +0900
X-Google-Sender-Auth: ZXy0x8pM0LdJoeiT50ZmYADWZ0Y
Message-ID: <CAH9JG2VWwdJ4t1B6fx9rx9=RMSmjmUvGSA5Eqn=aMcQ-FFyO0g@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] MAINTAINERS: Add Samsung pinctrl entries
From: Kyungmin Park <kmpark@infradead.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        linux-samsung-soc@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Joe Perches <joe@perches.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 7:17 AM, Doug Anderson <dianders@chromium.org> wrote:
> It's convenient if get_maintainer suggests sending samsung/exynos
> pinctrl changes to linux-samsung-soc and to Tomasz and Thomas.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> Changes in v2:
> - Updated with Thomas and Tomasz; removed Linus since he's already
>   there as part of the general pinctrl match.
>
>  MAINTAINERS | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8d97b3e..f55e3c7 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6284,6 +6284,16 @@ L:       linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  S:     Maintained
>  F:     drivers/pinctrl/pinctrl-at91.c
>
> +PIN CONTROLLER - SAMSUNG
> +M:     Tomasz Figa <t.figa@samsung.com>
> +M:     Thomas Abraham <thomas.abraham@linaro.org>
> +L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> +L:     linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
> +S:     Maintained
> +F:     drivers/pinctrl/pinctrl-exynos.*
> +F:     drivers/pinctrl/pinctrl-s3c*
> +F:     drivers/pinctrl/pinctrl-samsung.*
> +
>  PIN CONTROLLER - ST SPEAR
>  M:     Viresh Kumar <viresh.linux@gmail.com>
>  L:     spear-devel@list.st.com
> --
> 1.8.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
