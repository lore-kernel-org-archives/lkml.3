Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751561AbaKKNzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:55:54 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:47638 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaKKNzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:55:53 -0500
MIME-Version: 1.0
In-Reply-To: <1415624311-18980-1-git-send-email-bintian.wang@huawei.com>
References: <1415624311-18980-1-git-send-email-bintian.wang@huawei.com>
Date: Tue, 11 Nov 2014 21:55:52 +0800
Message-ID: <CAD6h2NSS5AYJ_1WmO1EvYC4TY2X4+2LuZAPPsXkdpBCGibM=Pg@mail.gmail.com>
Subject: Re: [PATCH] clk: hi3620: Move const initdata into correct code section
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: Bintian Wang <bintian.wang@huawei.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Zhangfei Gao <zhangfei.gao@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Jaehoon Chung <jh80.chung@samsung.com>, Xin Li <li.xin@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xinwei Hu <huxinwei@huawei.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 November 2014 20:58, Bintian Wang <bintian.wang@huawei.com> wrote:
> Use __initconst instead of __initdata for constant init data.
>
> Signed-off-by: Bintian Wang <bintian.wang@huawei.com>
> ---
>  drivers/clk/hisilicon/clk-hi3620.c | 70 +++++++++++++++++++-------------------
>  1 file changed, 35 insertions(+), 35 deletions(-)
>
> diff --git a/drivers/clk/hisilicon/clk-hi3620.c b/drivers/clk/hisilicon/clk-hi3620.c
> index 339945d..640ea33 100644
> --- a/drivers/clk/hisilicon/clk-hi3620.c
> +++ b/drivers/clk/hisilicon/clk-hi3620.c
> @@ -38,44 +38,44 @@
>  #include "clk.h"
>
>  /* clock parent list */
> -static const char *timer0_mux_p[] __initdata = { "osc32k", "timerclk01", };

Acked-by: Haojian Zhuang <haojian.zhuang@linaro.org>
