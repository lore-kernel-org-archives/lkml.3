Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934200Ab3ECTxm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 15:53:42 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:45180 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934031Ab3ECTxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 15:53:41 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-9-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-9-git-send-email-lee.jones@linaro.org>
Date: Fri, 3 May 2013 21:53:40 +0200
Message-ID: <CACRpkdbBWdxCHRjJ_Q-PF4bROnW6s7FXbCineuoxUEk_VJopUw@mail.gmail.com>
Subject: Re: [PATCH 08/63] dmaengine: ste_dma40: Move default memcpy configs
 into the driver
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

On Fri, May 3, 2013 at 4:31 PM, Lee Jones <lee.jones@linaro.org> wrote:

> There are only two default memcpy configurations used for the DMA40
> driver; one for physical memcpy and one for logical memcpy. Instead
> of invariably passing the same configurations though platform data,
> we're moving them into the driver instead.
>
> Acked-by: Vinod Koul <vnod.koul@intel.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied with some fuzzing to my ux500-dma40 branch.

Yours,
Linus Walleij
