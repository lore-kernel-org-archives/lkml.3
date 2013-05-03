Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934313Ab3ECUPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 16:15:19 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:49430 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934192Ab3ECUPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 16:15:17 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-18-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-18-git-send-email-lee.jones@linaro.org>
Date: Fri, 3 May 2013 22:15:16 +0200
Message-ID: <CACRpkdatVVLX8S=OGUFs-ab+HZ6mrj6nyqCxg_YzojNJ=FJPoQ@mail.gmail.com>
Subject: Re: [PATCH 17/63] dmaengine: ste_dma40: Calculate number of logical
 channels from physical ones
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 4:32 PM, Lee Jones <lee.jones@linaro.org> wrote:

> This change will cost ~25KB of memory, but it's worth the trade-off,
> as it removes a great deal of overhead. It means that instead of only
> allocating memory for the logical channels in use, it does so for all
> available ones, which is 32 per physical channel. However, this now
> means we can remove some platform data and we don't have to worry
> about adding vendor specific variables to Device Tree.
>
> Acked-by: Vinod Koul <vnod.koul@intel.com>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied to my ux500-dma40 branch.

Thanks!
Linus Walleij
