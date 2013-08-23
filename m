Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab3HWSDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 14:03:12 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:41350 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab3HWSDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 14:03:11 -0400
MIME-Version: 1.0
In-Reply-To: <1377131642-19494-1-git-send-email-festevam@gmail.com>
References: <1377131642-19494-1-git-send-email-festevam@gmail.com>
Date: Fri, 23 Aug 2013 20:03:10 +0200
Message-ID: <CACRpkdYT7AMosUKBF5qMQbFBsbh2MoTbrhqR07Y_dPvUSwO7xQ@mail.gmail.com>
Subject: Re: [PATCH] dma: ste_dma: Fix warning when CONFIG_ARM_LPAE=y
From: Linus Walleij <linus.walleij@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Kevin Hilman <khilman@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 22, 2013 at 2:34 AM, Fabio Estevam <festevam@gmail.com> wrote:

> From: Fabio Estevam <fabio.estevam@freescale.com>
>
> When CONFIG_ARM_LPAE=y the following build warning are generated:
>
> drivers/dma/ste_dma40.c:3228:2: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'resource_size_t' [-Wformat]
> drivers/dma/ste_dma40.c:3582:3: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'resource_size_t' [-Wformat]
> drivers/dma/ste_dma40.c:3582:3: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'resource_size_t' [-Wformat]
> drivers/dma/ste_dma40.c:3593:5: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'resource_size_t' [-Wformat]
>
> According to Documentation/printk-formats.txt '%pa' can be used to properly
> print 'resource_size_t'.
>
> Also, for printing memory region the '%pr' is more convenient.
>
> Reported-by: Kevin Hilman <khilman@linaro.org>
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Elegant!
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Vinod, can you apply this?

Yours,
Linus Walleij
