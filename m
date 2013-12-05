Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab3LEKJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 05:09:21 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:59634 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142Ab3LEKJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:09:15 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH] MAINTAINERS: Add entry for Samsung SoC clock drivers
Date: Thu, 05 Dec 2013 11:09:10 +0100
Message-ID: <1965675.1ZOPt5drrV@flatron>
User-Agent: KMail/4.11.3 (Linux/3.12.0-gentoo; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1383963454-2749-1-git-send-email-tomasz.figa@gmail.com>
References: <1383963454-2749-1-git-send-email-tomasz.figa@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday 09 of November 2013 03:17:34 Tomasz Figa wrote:
> From: Tomasz Figa <t.figa@samsung.com>
> 
> This patch adds an entry for Samsung SoC clock drivers located under
> drivers/clk/samsung/ directory, with me taking the maintainer role.
> 
> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Acked-by: Mike Turquette <mturquette@linaro.org>
> Acked-by: Sachin Kamat <sachin.kamat@linaro.org>
> Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> ---
>  MAINTAINERS | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 61b8757..df7e1bf 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7319,6 +7319,12 @@ L:	linux-media@vger.kernel.org
>  S:	Supported
>  F:	drivers/media/i2c/s5c73m3/*
>  
> +SAMSUNG SOC CLOCK DRIVERS
> +M:	Tomasz Figa <t.figa@samsung.com>
> +S:	Supported
> +L:	linux-samsung-soc@vger.kernel.org (moderated for non-subscribers)
> +F:	drivers/clk/samsung/
> +
>  SERIAL DRIVERS
>  M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>  L:	linux-serial@vger.kernel.org
> 

I don't see this patch applied anywhere. Mike, should it go through your
tree?

Best regards,
Tomasz

