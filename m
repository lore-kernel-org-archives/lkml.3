Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab3H0XRA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 19:17:00 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:55795 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab3H0XQ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 19:16:59 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1377638890-371-16-git-send-email-sebastian.hesselbarth@gmail.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1377638890-371-16-git-send-email-sebastian.hesselbarth@gmail.com>
Message-ID: <20130827231653.8231.41009@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH RFC v2 15/16] clk: vt8500: remove call to of_clk_init
Date: Tue, 27 Aug 2013 16:16:53 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sebastian Hesselbarth (2013-08-27 14:28:09)
> With arch/arm calling of_clk_init(NULL) from time_init(), we can now
> remove it from corresponding drivers/clk code.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Acked-by: Mike Turquette <mturquette@linaro.org>

> ---
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/clk/clk-vt8500.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clk/clk-vt8500.c b/drivers/clk/clk-vt8500.c
> index 82306f5..218d7ba 100644
> --- a/drivers/clk/clk-vt8500.c
> +++ b/drivers/clk/clk-vt8500.c
> @@ -701,6 +701,4 @@ void __init vtwm_clk_init(void __iomem *base)
>                 return;
>  
>         pmc_base = base;
> -
> -       of_clk_init(NULL);
>  }
> -- 
> 1.7.2.5
