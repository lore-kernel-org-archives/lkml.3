Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153Ab3HGNw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 09:52:59 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:42465 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724Ab3HGNw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 09:52:58 -0400
MIME-Version: 1.0
In-Reply-To: <1375309877-16617-6-git-send-email-sboyd@codeaurora.org>
References: <1375309877-16617-1-git-send-email-sboyd@codeaurora.org>
	<1375309877-16617-6-git-send-email-sboyd@codeaurora.org>
Date: Wed, 7 Aug 2013 15:52:57 +0200
Message-ID: <CACRpkdaCn74S0WbZ+fuN_ZpKAS0eiYyOe9w-pPLbQeFquEogyA@mail.gmail.com>
Subject: Re: [PATCH 05/18] ARM: integrator: Switch to sched_clock_register()
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

For this patch (given the idea is accepted)
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
