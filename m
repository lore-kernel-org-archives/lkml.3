Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab3E0OF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 10:05:59 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:37333 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932501Ab3E0OF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 10:05:58 -0400
MIME-Version: 1.0
In-Reply-To: <1369663420-3881-1-git-send-email-rabin.vincent@stericsson.com>
References: <1369663420-3881-1-git-send-email-rabin.vincent@stericsson.com>
Date: Mon, 27 May 2013 16:05:57 +0200
Message-ID: <CACRpkdbHYeU3wgNkVtGEeuLUUKjFHZkdz01vpObgN4KVO8BvVw@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: ste_dma40: fix pm runtime ref counting
From: Linus Walleij <linus.walleij@linaro.org>
To: Rabin Vincent <rabin.vincent@stericsson.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Rabin Vincent <rabin@rab.in>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 4:03 PM, Rabin Vincent
<rabin.vincent@stericsson.com> wrote:

> The pm runtime reference counting of the driver is broken for the case
> when there is more than one transfer queued, leading to the device being
> runtime suspend while active.  Fix it.
>
> Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>

Looks good to me.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Vinod, are you taking this for fixes?

Yours,
Linus Walleij
