Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab3HGSzD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:55:03 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:34526 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab3HGSzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:55:00 -0400
MIME-Version: 1.0
In-Reply-To: <1375309877-16617-14-git-send-email-sboyd@codeaurora.org>
References: <1375309877-16617-1-git-send-email-sboyd@codeaurora.org>
	<1375309877-16617-14-git-send-email-sboyd@codeaurora.org>
Date: Wed, 7 Aug 2013 20:55:00 +0200
Message-ID: <CACRpkdY0Ka6QNmM10hfDd5aLfoZ_mZT3W=x6dS4wcixabyPbuA@mail.gmail.com>
Subject: Re: [PATCH 13/18] ARM: u300: Switch to sched_clock_register()
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 1, 2013 at 12:31 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:

> The 32 bit sched_clock interface now supports 64 bits. Upgrade to
> the 64 bit function to allow us to remove the 32 bit registration
> interface.
>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
