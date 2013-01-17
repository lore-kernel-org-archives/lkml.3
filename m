Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381Ab3AQJcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 04:32:42 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:51513 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759317Ab3AQJck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 04:32:40 -0500
MIME-Version: 1.0
In-Reply-To: <1358413763-21507-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358413763-21507-1-git-send-email-thierry.reding@avionic-design.de>
Date: Thu, 17 Jan 2013 15:02:39 +0530
X-Google-Sender-Auth: T5BDGbZQkB4lVir_C3s-0qrmNcY
Message-ID: <CAOh2x=m4NKbaVAzVNpLifS8rs1Yk=B=gYa-XYjNd3DgxhfZMjQ@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: spear3xx: Fix pl080-related build failure
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Shiraz Hashim <shiraz.hashim@st.com>, spear-devel@list.st.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 2:39 PM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> Include linux/amba/pl080.h to pull in the various PL080_* macros.
>
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> ---
>  arch/arm/mach-spear3xx/spear3xx.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/mach-spear3xx/spear3xx.c b/arch/arm/mach-spear3xx/spear3xx.c
> index f9d754f..7c218d9 100644
> --- a/arch/arm/mach-spear3xx/spear3xx.c
> +++ b/arch/arm/mach-spear3xx/spear3xx.c
> @@ -14,6 +14,7 @@
>  #define pr_fmt(fmt) "SPEAr3xx: " fmt
>
>  #include <linux/amba/pl022.h>
> +#include <linux/amba/pl080.h>
>  #include <linux/amba/pl08x.h>
>  #include <linux/io.h>
>  #include <plat/pl080.h>

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
