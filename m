Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191AbaE0Jbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 05:31:52 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:37882 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbaE0Jbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 05:31:50 -0400
MIME-Version: 1.0
In-Reply-To: <1400890613-5704-3-git-send-email-sboyd@codeaurora.org>
References: <1400890613-5704-3-git-send-email-sboyd@codeaurora.org>
Date: Tue, 27 May 2014 11:31:50 +0200
Message-ID: <CACRpkdZDORBMEFXaG_rHg9qnV0Kxxp4vy03m6L7mUh85rad-Gg@mail.gmail.com>
Subject: Re: [PATCH] clk: u300: Terminate of match table
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2014 at 2:16 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> Failure to terminate this match table can lead to boot failures
> depending on where the compiler places the match table.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
