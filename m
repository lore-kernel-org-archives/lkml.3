Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875Ab3E2PqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:46:19 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:61407 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab3E2PqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:46:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd9kMzZ_ZY6zm0MZ+P6dHq73i_GdCsxhpUOt-V9nf08tWA@mail.gmail.com>
References: <CAPgLHd9kMzZ_ZY6zm0MZ+P6dHq73i_GdCsxhpUOt-V9nf08tWA@mail.gmail.com>
Date: Wed, 29 May 2013 17:46:17 +0200
Message-ID: <CACRpkdZpReWCaA7=-5xPfd9y5jDfP-P+5VqFCuo4Aa7LQ31Qhw@mail.gmail.com>
Subject: Re: [PATCH -next] dmaengine: ste_dma40: add missing iounmap() on
 error in d40_probe()
From: Linus Walleij <linus.walleij@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wei,

why does the patch subject say -next?

AFAICS the patch applies to Torvalds tree as well, and should probably
go in for fixes.

On Tue, May 28, 2013 at 11:07 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Add the missing iounmap() before return from d40_probe()
> in the error handling case.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

I guess Vinod should apply this... maybe it should even be marked
for stable.

Yours,
Linus Walleij
