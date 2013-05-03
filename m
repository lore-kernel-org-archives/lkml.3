Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934329Ab3ECUR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 16:17:27 -0400
Received: from mail-ia0-f171.google.com ([209.85.210.171]:57714 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934031Ab3ECUR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 16:17:26 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-19-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-19-git-send-email-lee.jones@linaro.org>
Date: Fri, 3 May 2013 22:17:26 +0200
Message-ID: <CACRpkda2+49CjTOBcnfjp=EXOhOnrLHz4K+yOH-bKp+s7OmpsA@mail.gmail.com>
Subject: Re: [PATCH 18/63] dmaengine: ste_dma40: Remove 'always true' checking
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 4:32 PM, Lee Jones <lee.jones@linaro.org> wrote:

> Before allocating memory for logical channels, the current driver
> checks to see if there are any. Well as the dma40_memcpy_channels[]
> array is always populated, the check is always true. Best to
> remove the check.
>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Tentatively applied to my ux500-dma40 branch.

Vinod, can I have your ACK on this patch?

Yours,
Linus Walleij
