Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbbAWK4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:56:39 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:65304 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbbAWK4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:56:37 -0500
MIME-Version: 1.0
In-Reply-To: <1421955259-8875-1-git-send-email-sboyd@codeaurora.org>
References: <1421955259-8875-1-git-send-email-sboyd@codeaurora.org>
Date: Fri, 23 Jan 2015 11:56:36 +0100
Message-ID: <CACRpkdY8vDwSpTWkGPTkAHsqhFdhFDTy7zohWFoa8TF=yj4+Yg@mail.gmail.com>
Subject: Re: [PATCH] clk: ux500: Drop use of clk-private.h
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 8:34 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> These drivers don't need to include clk-private.h. Remove the
> include.
>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
