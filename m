Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402Ab3DZJki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 05:40:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64490 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758848Ab3DZJkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:40:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH] dmaengine: use phys_addr_t for slave configuration
Date: Fri, 26 Apr 2013 11:40:41 +0200
Message-ID: <6218023.boWEpJUXtx@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.8.0-17-generic; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1366967214-20776-1-git-send-email-linus.walleij@linaro.org>
References: <1366967214-20776-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:TNdAvFUHje/C3umJYg8XOM2ibI8Fge8yImekF2SVoo+
 IsYp+X/cNzBhgn80QMkAyxD5DetRVj/sSGoVQ/Z/UcUvKu6Ll5
 FZOAjCwdzii5sUEb1xUn7E3dFL2wVIoMICc3AaUBbSgM88y4kA
 tjrJmC4w3h0iTHdnh0w+XeFMlZ4i3xFQUlexqZGGyZdUddUg3b
 JwHObYoQS7+WZpVBtA93aJqunA34spkBh/X3n8Q6Ks1fojKrap
 t+HF8Z36RF8OEifAiQG4NC/mzWWZar7CHYEihofb0Nw56tw7q4
 ffPUmLJ/y/ZssbZngt0TX72BKchmPb+d7aSgikuyqkUba/oObh
 jFbNqZTbNWeH4wI63eZY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 April 2013 11:06:54 Linus Walleij wrote:
> The documentation already says these are physical addresses, and
> we have concluded that any translation into the DMA address space
> needs to reside in the dmaengine driver, so change the type of
> the passed arguments.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
