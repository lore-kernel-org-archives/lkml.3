Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758247Ab3EAO2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 10:28:53 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:39200 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab3EAO2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 10:28:46 -0400
Date: Wed, 1 May 2013 15:28:41 +0100
From: Lee Jones <lee.jones@linaro.org>
To: vinod.koul@intel.com
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>,
        linus.walleij@linaro.org
Subject: Re: [PATCH 08/32 v2] dmaengine: ste_dma40: Remove home-brew MAX()
 macro
Message-ID: <20130501142841.GF25256@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-9-git-send-email-lee.jones@linaro.org>
 <20130424084912.GH17416@gmail.com>
 <CACRpkdaaa+gmsimkJVmhwv+zE+4ZmgZQ=AtHPry9=_EMScMC=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdaaa+gmsimkJVmhwv+zE+4ZmgZQ=AtHPry9=_EMScMC=w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The current implementation of the DMA40's local MAX() macro evaluates
> > its arguments more times than is necessary and it not type checked.
> > This patch strips replaces it with a new, more efficient constant.
> >
> > Cc: Vinod Koul <vinod.koul@intel.com>
> > Cc: Dan Williams <djbw@fb.com>
> > Cc: Per Forlin <per.forlin@stericsson.com>
> > Cc: Rabin Vincent <rabin@rab.in>
> > Reported-by: Harvey Harrison <harvey.harrison@gmail.com>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Ah this v2 version is OK, atleast it makes the kernel look nicer.
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Vinod, poke.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
