Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab3ETMck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 08:32:40 -0400
Received: from mail-ia0-f172.google.com ([209.85.210.172]:50551 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755480Ab3ETMcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 08:32:39 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-13-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-13-git-send-email-lee.jones@linaro.org>
Date: Mon, 20 May 2013 14:32:38 +0200
Message-ID: <CACRpkdY3TvuYjT-YEMcG1gfMTHs7Zz_rNvo+00z4Gqg4uPc63Q@mail.gmail.com>
Subject: Re: [PATCH 12/63] dmaengine: ste_dma40: Remove home-brew MAX() macro
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, Vinod Koul <vinod.koul@intel.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 4:31 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The current implementation of the DMA40's local MAX() macro evaluates
> its arguments more times than is necessary and it not type checked.
> This patch strips replaces it with a new, more efficient constant.
>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Per Forlin <per.forlin@stericsson.com>
> Cc: Rabin Vincent <rabin@rab.in>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Reported-by: Harvey Harrison <harvey.harrison@gmail.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Still waiting for Vinod's ACK on this as well.

Vinod?

Yours,
Linus Walleij
