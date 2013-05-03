Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763441Ab3ECUEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 16:04:21 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:35665 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab3ECUEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 16:04:20 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-13-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-13-git-send-email-lee.jones@linaro.org>
Date: Fri, 3 May 2013 22:04:19 +0200
Message-ID: <CACRpkdZcEFkuPeCk+ef2QJeWr+4MXBcjyNpASrH9btTb2TR_YQ@mail.gmail.com>
Subject: Re: [PATCH 12/63] dmaengine: ste_dma40: Remove home-brew MAX() macro
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

Patch applied to my ux500-dma40 branch with some fuzzing.

Thanks!
Linus Walleij
