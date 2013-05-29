Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965669Ab3E2S2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 14:28:11 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:34006 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965160Ab3E2S2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 14:28:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd-Mw4MQwS8=p9+ZBHHehH7B-Hs49BqiUMrq-aV_5M4pQQ@mail.gmail.com>
References: <CAPgLHd-Mw4MQwS8=p9+ZBHHehH7B-Hs49BqiUMrq-aV_5M4pQQ@mail.gmail.com>
Date: Wed, 29 May 2013 20:27:59 +0200
Message-ID: <CACRpkdZH8jai84q6uwSRjMR+HCzohH-JMaKw1SCShYwgSKJYXQ@mail.gmail.com>
Subject: Re: [PATCH -next] dmaengine: ste_dma40: fix error return code in d40_probe()
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

On Tue, May 28, 2013 at 11:06 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> In many of the error handling case, the return value 'ret' not set
> and 0 will be return from d40_probe() even if error, but we should
> return a negative error code instead in those error handling case.
> This patch fixed them, and also removed useless variable 'err'.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Hm it seems it does not apply on my dma40 branch (the same
as mentioned by Andy):
https://git.kernel.org/cgit/linux/kernel/git/linusw/linux-stericsson.git/log/?h=ux500-dma40

I have already queued some 36 patches from this branch into
ARM SoC so it is in -next today (and conflicting with this patch).

Could you rebase it and get Vinod's ACK so I can queue it?

Also pls include Lee Jones on CC.

Yours,
Linus Walleij
