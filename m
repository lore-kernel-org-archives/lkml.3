Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783AbaGaWZs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 18:25:48 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:54099 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbaGaWZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 18:25:47 -0400
Message-ID: <53DAC266.4080102@gmail.com>
Date: Fri, 01 Aug 2014 00:25:42 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Humberto Silva Naves <hsnaves@gmail.com>,
        linux-samsung-soc@vger.kernel.org
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Andreas Farber <afaerber@suse.de>
Subject: Re: [PATCH] clk: samsung: Changed return behavior of samsung_clk_init
References: <1406843002-15652-1-git-send-email-hsnaves@gmail.com>
In-Reply-To: <1406843002-15652-1-git-send-email-hsnaves@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Humberto,

On 31.07.2014 23:43, Humberto Silva Naves wrote:
> Instead of invoking panic, the samsung_clk_init returns a NULL
> pointer to indicate that an error has occurred. All the drivers
> using this function were changed appropriately (in this case
> just the clk-exynos5410).
> 
> This patch was suggested by Tomasz Figa in
> http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg34982.html

There is a Suggested-by tag that can be added before your sign-off.
Similarly there are few other useful tags which are good to know.

> 
> Signed-off-by: Humberto Silva Naves <hsnaves@gmail.com>
> ---
>  drivers/clk/samsung/clk-exynos5410.c |    2 ++
>  drivers/clk/samsung/clk.c            |    8 +++++---
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 

In general the patch looks good, thanks for you work. Will wait some
time to let people review it and then apply.

As a side note, it is always good to say why the patch is good in commit
message, so that maintainers know that author knows what he does, they
indeed want this patch and people that would stumble upon this patch in
future could know the rationale behind this change. This patch is pretty
trivial, though, so I'll let it go this time.

Best regards,
Tomasz
