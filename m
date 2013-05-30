Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965793Ab3E3RkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 13:40:07 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:52624 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965609Ab3E3RkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 13:40:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAPgLHd_DTQ8Ncc6a7uin8zMY+Uy+zdX56RGVBE5VtVdtMB+gXA@mail.gmail.com>
References: <CAPgLHd_DTQ8Ncc6a7uin8zMY+Uy+zdX56RGVBE5VtVdtMB+gXA@mail.gmail.com>
Date: Thu, 30 May 2013 19:40:01 +0200
Message-ID: <CACRpkdZhBgQ5FokyHsyB3K2T7_cBQdg0vPrBY3W79E67ScfvvQ@mail.gmail.com>
Subject: Re: [PATCH -next] gpio-ml-ioh: fix error return code in ioh_gpio_probe()
From: Linus Walleij <linus.walleij@linaro.org>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 5:11 PM, Wei Yongjun <weiyj.lk@gmail.com> wrote:

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fix to return a negative error code in the irq descs alloc error
> handling case instead of 0, as done elsewhere in this function.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Patch applied.

Yours,
Linus Walleij
