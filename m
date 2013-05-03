Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934355Ab3ECVQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 17:16:18 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:50754 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934261Ab3ECVQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 17:16:14 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-32-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-32-git-send-email-lee.jones@linaro.org>
Date: Fri, 3 May 2013 23:16:13 +0200
Message-ID: <CACRpkdZgPs1i=Lna41di97jZ2h-=_XzfZXMN8z9QFa-U-Avxog@mail.gmail.com>
Subject: Re: [PATCH 31/63] dmaengine: ste_dma40: Only use addresses passed as
 configuration information
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

> Addresses are passed in from the client's driver via the invocation of
> dmaengine_slave_config(), so there's no need to fetch them from platform
> data too, hardwired or otherwise. This is a great step forward, as it
> elevates a large burden from platform data in the way of a look-up
> table.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

I get uncertain at this point and need Vinod's ACK so I stop
applying patches here.

Please base further submissions on my ux500-dma40 branch to
avoid resending already applied patches, if possible. (Atleast
that make things convenient for me.)

Is it possible to move patches with hairy dependencies
toward the end of the series or something?

Yours,
Linus Walleij
