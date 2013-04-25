Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848Ab3DYMsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 08:48:38 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:65313 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab3DYMsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 08:48:37 -0400
MIME-Version: 1.0
In-Reply-To: <20130424084912.GH17416@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-9-git-send-email-lee.jones@linaro.org>
	<20130424084912.GH17416@gmail.com>
Date: Thu, 25 Apr 2013 14:48:34 +0200
Message-ID: <CACRpkdaaa+gmsimkJVmhwv+zE+4ZmgZQ=AtHPry9=_EMScMC=w@mail.gmail.com>
Subject: Re: [PATCH 08/32 v2] dmaengine: ste_dma40: Remove home-brew MAX() macro
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 24, 2013 at 10:49 AM, Lee Jones <lee.jones@linaro.org> wrote:

> The current implementation of the DMA40's local MAX() macro evaluates
> its arguments more times than is necessary and it not type checked.
> This patch strips replaces it with a new, more efficient constant.
>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Reported-by: Harvey Harrison <harvey.harrison@gmail.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Ah this v2 version is OK, atleast it makes the kernel look nicer.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
