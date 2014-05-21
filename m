Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbaEUWwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:52:16 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:46510 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbaEUWwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:52:15 -0400
MIME-Version: 1.0
In-Reply-To: <1397550585-7248-1-git-send-email-linus.walleij@linaro.org>
References: <1397550585-7248-1-git-send-email-linus.walleij@linaro.org>
Date: Thu, 22 May 2014 00:52:13 +0200
Message-ID: <CACRpkdZi9ippzqqsHzJ0K=m=z0T6_FdkLuES7ZhrKn-spdrJeA@mail.gmail.com>
Subject: Re: [PATCH] clk: impd1: add pclk clocks
From: Linus Walleij <linus.walleij@linaro.org>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 10:29 AM, Linus Walleij
<linus.walleij@linaro.org> wrote:

> The IM-PD1 PrimeCells all have pclk assignments though this clock
> cannot be controlled, and we need to provide this as a dummy
> clock for the PL061 GPIO driver to probe, so let's assign it to
> all the cells on the board.
>
> Cc: Mike Turquette <mturquette@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Mike, ping are you taking this patch to the clk tree?

Yours,
Linus Walleij
