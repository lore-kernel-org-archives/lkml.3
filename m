Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab3ETMiF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 08:38:05 -0400
Received: from mail-ia0-f179.google.com ([209.85.210.179]:63963 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756105Ab3ETMiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 08:38:03 -0400
MIME-Version: 1.0
In-Reply-To: <1367610578-2437-1-git-send-email-linus.walleij@stericsson.com>
References: <1367610578-2437-1-git-send-email-linus.walleij@stericsson.com>
Date: Mon, 20 May 2013 14:38:03 +0200
Message-ID: <CACRpkdabxQ1mgvPiVfHjCVk4y_cGp-QML6ZLxQ3J1mJ43Zjdug@mail.gmail.com>
Subject: Re: [PATCH] dma: ste_dma40: fix up static memcpy event lines
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Walleij <linus.walleij@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Anmar Oueja <anmar.oueja@linaro.org>, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 9:49 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:

> From: Linus Walleij <linus.walleij@linaro.org>
>
> The commit
> "dmaengine: ste_dma40: Assign memcpy channels in the driver"
> had two problems:
> - It assigned magic numbers to the memcpy event lines
>   instead of giving them symbolic names.
> - It seems to have missed one of the memcpy event lines,
>   number 51.
>
> This patch fixes it up.
>
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Vinod: seeking an ACK for this to take it with the rest of
> Lee's patches in a DMA40 branch in ARM SoC.

Vinod, ping on this as well...

Yours,
Linus Walleij
