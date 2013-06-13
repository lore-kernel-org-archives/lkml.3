Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607Ab3FMRN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 13:13:26 -0400
Received: from mail-ea0-f175.google.com ([209.85.215.175]:33006 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab3FMRNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 13:13:24 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-samsung-soc@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        "David S. Miller" <davem@davemloft.net>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-kernel@vger.kernel.org,
        thomas.abraham@linaro.org
Subject: Re: [PATCH] MAINTAINERS: Add Samsung pinctrl entries
Date: Thu, 13 Jun 2013 19:13:21 +0200
Message-ID: <9948950.GZ51yJYkxQ@flatron>
User-Agent: KMail/4.10.4 (Linux/3.9.5-gentoo; KDE/4.10.4; x86_64; ; )
In-Reply-To: <1371143144-31764-1-git-send-email-dianders@chromium.org>
References: <1371143144-31764-1-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 of June 2013 10:05:44 Doug Anderson wrote:
> It's convenient if get_maintainer suggests sending samsung/exynos
> pinctrl changes to linux-samsung-soc and to Kukjin.  Add an entry for
> that.

Well, if we are already at it, we could list the actual maintainers of the 
driver.

The original maintainer was Thomas Abraham <thomas.abraham@linaro.org> 
(added to CC) and after joining to development of this driver last year I 
have become a de facto maintainer as well, so...

> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  MAINTAINERS | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 8d97b3e..d026e38 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6284,6 +6284,16 @@ L:	linux-arm-kernel@lists.infradead.org
> (moderated for non-subscribers) S:	Maintained
>  F:	drivers/pinctrl/pinctrl-at91.c
> 
> +PIN CONTROLLER - SAMSUNG
> +M:	Linus Walleij <linus.walleij@linaro.org>
> +M:	Kukjin Kim <kgene.kim@samsung.com>

So actually this would be:
M:	Thomas Abraham <thomas.abraham@linaro.org>
M:	Tomasz Figa <t.figa@samsung.com>

Thomas, do you agree on this?

Best regards,
Tomasz

> +L:	linux-arm-kernel@lists.infradead.org (moderated for non-
subscribers)
> +L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
> +S:	Maintained
> +F:	drivers/pinctrl/pinctrl-exynos.*
> +F:	drivers/pinctrl/pinctrl-s3c*
> +F:	drivers/pinctrl/pinctrl-samsung.*
> +
>  PIN CONTROLLER - ST SPEAR
>  M:	Viresh Kumar <viresh.linux@gmail.com>
>  L:	spear-devel@list.st.com
